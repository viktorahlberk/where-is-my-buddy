package main

import (
	"encoding/json"
	"fmt"
	"kahoot/src"
	"kahoot/src/database"
	"kahoot/src/handlers"
	"kahoot/src/models"
	"log"
	"net/http"
)

func main() {
	database.InitTables()
	src.PrintLocalIp()

	http.HandleFunc("/update", handleUpdate)
	http.HandleFunc("/lastposition", handlers.HandleLastPosition)
	http.HandleFunc("/getfriends", handlers.HandleGetFriends)
	http.HandleFunc("/getinvites", handlers.HandleGetInvites)
	http.HandleFunc("/search", handlers.HandleSearch)
	http.HandleFunc("/invite", handlers.HandleInvite)
	http.HandleFunc("/acceptinvitation", handlers.AcceptInvitationHandler)
	http.HandleFunc("/declineinvitation", handlers.DeclineInvitationHandler)
	http.HandleFunc("/deletefriend", handlers.DeleteFriendHandler)
	// http.HandleFunc("/reg", handlers.HandleReg)

	// Start the server
	port := 8080
	fmt.Printf("Starting server on port %d...\n", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", port), nil))
}

// func handleUsers(w http.ResponseWriter, r *http.Request) {
// 	if r.Method == http.MethodGet {
// 		fmt.Println("Received.")
// 	} else {
// 		http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
// 	}
// }

func handleUpdate(w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	var u models.User
	err := decoder.Decode(&u)
	if err != nil {
		panic(err)
	}

	// log.Println(u)
	database.UpdateUserPosition(u)
}
