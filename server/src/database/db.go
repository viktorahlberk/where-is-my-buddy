package database

import (
	"database/sql"
	"kahoot/src/models"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func openDb() *sql.DB {
	db, err := sql.Open("sqlite3", "./database.db")
	if err != nil {
		log.Fatal(err)
	}
	return db
}

func InitTables() {
	db := openDb()
	defer db.Close()
	tables := []string{
		`CREATE TABLE IF NOT EXISTS users(
		user_id INTEGER PRIMARY KEY,
		email TEXT NOT NULL,
		latitude TEXT,
		longitude TEXT
	);`,
		`CREATE TABLE IF NOT EXISTS friendships(
		friendship_id INTEGER PRIMARY KEY,
		user_email TEXT,
		friend_email TEXT,
		confirmed INTEGER
	);`,
	}
	for _, table := range tables {
		_, err := db.Exec(table)
		if err != nil {
			log.Fatal(err)
		}
	}
}

func InsertNewUser(u models.User) bool {
	db := openDb()
	defer db.Close()
	statement, err := db.Prepare(`INSERT INTO users(
		email,
		latitude,
		longitude		
	) VALUES (?,?,?)`)
	if err != nil {
		log.Println(err)
		return false
	}
	_, err = statement.Exec(u.Email, u.Latitude, u.Longitude)
	if err != nil {
		log.Println(err)
		return false
	}
	return true
}
func EmailExists(email string) bool {
	db := openDb()
	defer db.Close()
	username := ""
	sqlStmt := `SELECT email FROM users WHERE email = ?`
	err := db.QueryRow(sqlStmt, email).Scan(&username)
	if err != nil {
		if err != sql.ErrNoRows {
			// a real error happened! you should change your function return
			// to "(bool, error)" and return "false, err" here
			log.Print(err)
		}
		return false
	}
	return true
}
func UpdateUserPosition(u models.User) {
	db := openDb()
	defer db.Close()

	if EmailExists(u.Email) {
		statement, err := db.Prepare(`UPDATE users
	SET latitude = ?,longitude = ?
	WHERE email = ?`)
		if err != nil {
			print("Error creating database statement")
			log.Println(err)
		}
		_, err = statement.Exec(u.Email, u.Latitude, u.Longitude)
		if err != nil {
			print("Error executing database statement")
			log.Println(err)
		}
	} else {
		InsertNewUser(u)
	}
}
func InsertFriendShip(friendEmail string, userEmail string) {
	db := openDb()
	defer db.Close()
	statement, err := db.Prepare("INSERT INTO friendships(user_email, friend_email, confirmed)VALUES(?,?,?)")
	if err != nil {

		log.Println(err)
	}
	_, err = statement.Exec(userEmail, friendEmail, 0)
	if err != nil {
		log.Println(err)
	}
}

func GetUserFriends(userEmail string) []string {
	log.Println("Backend GetUserFriends func")
	db := openDb()
	defer db.Close()
	rows, err := db.Query("SELECT * FROM friendships WHERE confirmed = 1 AND (user_email=? OR friend_email=?)", userEmail, userEmail)
	if err != nil {
		log.Println(err)
	}
	defer rows.Close()

	type Friendship struct {
		id          string
		userEmail   string
		friendEmail string
		confirmed   int
	}
	slice := []Friendship{}
	slice2 := []string{}
	for rows.Next() {
		v := Friendship{}
		err = rows.Scan(&v.id, &v.userEmail, &v.friendEmail, &v.confirmed)
		if err != nil {
			log.Println(err)
		}
		slice = append(slice, v)
	}
	// fmt.Println(slice)
	if len(slice) > 0 {
		user := slice[0].userEmail
		friend := slice[0].friendEmail
		if userEmail == user {
			slice2 = append(slice2, friend)
		} else {
			slice2 = append(slice2, user)
		}
	}
	return slice2

}
func GetUserFriendInvites(userEmail string) []string {
	log.Println("Backend GetUserFriendInvites func")
	db := openDb()
	defer db.Close()
	rows, err := db.Query("SELECT friend_email FROM friendships WHERE user_email = ? AND confirmed = 0", userEmail)
	if err != nil {
		log.Println(err)
	}
	defer rows.Close()
	slice := []string{}
	for rows.Next() {
		v := ""
		rows.Scan(&v)
		// fmt.Println(v)
		slice = append(slice, v)
	}
	// fmt.Println(slice)
	return slice
}
func DeclineInvitation(userEmail string, invitation string) {
	log.Println("DB DeclineInvitation func ")
	db := openDb()
	defer db.Close()

	statement, err := db.Prepare("DELETE FROM friendships WHERE user_email=? AND friend_email=? AND confirmed=0")
	if err != nil {
		log.Println(err)
	}
	_, err = statement.Exec(userEmail, invitation)
	if err != nil {
		log.Println(err)
	}
}
func AcceptInvitation(userEmail string, invitation string) {
	log.Println("DB AcceptInvitation func ")
	db := openDb()
	defer db.Close()
	statement, err := db.Prepare("UPDATE friendships SET confirmed=1 WHERE user_email=? AND friend_email=?")
	if err != nil {
		log.Println(err)
	}
	_, err = statement.Exec(userEmail, invitation)
	if err != nil {
		log.Println(err)
	}
}
func DeleteFriend(userEmail string, friendEmail string) {
	log.Println("BACKEND DELETE FRIEND FUNC!!")
	db := openDb()
	defer db.Close()
	statement, err := db.Prepare("DELETE FROM friendships WHERE confirmed=1 AND ((user_email=? AND friend_email=?) OR (friend_email=? AND user_email=?))")
	if err != nil {
		log.Println(err)
	}
	_, err = statement.Exec(userEmail, friendEmail, userEmail, friendEmail)
	if err != nil {
		log.Println(err)
	}
}
func GetUserLastPosition(email string) models.User {
	db := openDb()
	defer db.Close()
	user := models.User{}
	sqlStmt := `SELECT * FROM users WHERE email = ?`
	err := db.QueryRow(sqlStmt, email).Scan(&user.Id, &user.Email, &user.Latitude, &user.Longitude)
	if err != nil {
		if err != sql.ErrNoRows {
			// a real error happened! you should change your function return
			// to "(bool, error)" and return "false, err" here
			log.Print(err)
		}
		log.Println(err)
	}
	return user
}
