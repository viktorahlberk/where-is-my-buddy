package handlers

import (
	"encoding/json"
	"io"
	"kahoot/src/database"
	"log"
	"net/http"
	"strings"
)

func HandleGetFriends(w http.ResponseWriter, r *http.Request) {
	bodyBytes, err := io.ReadAll(r.Body)
	defer r.Body.Close()
	if err != nil {
		log.Println(err)
	}
	userEmail := string(bodyBytes)
	type Response struct {
		Friends []string `json:"friends"`
	}

	f := database.GetUserFriends(userEmail)
	j, _ := json.Marshal(Response{Friends: f})

	w.Write(j)
}
func HandleGetInvites(w http.ResponseWriter, r *http.Request) {
	bodyBytes, err := io.ReadAll(r.Body)
	defer r.Body.Close()
	if err != nil {
		log.Println(err)
	}
	userEmail := string(bodyBytes)
	type Response struct {
		Invites []string `json:"invites"`
	}

	invites := database.GetUserFriendInvites(userEmail)
	json, _ := json.Marshal(Response{Invites: invites})

	w.Write(json)
}
func HandleSearch(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		bodyBytes, err := io.ReadAll(r.Body)
		defer r.Body.Close()
		if err != nil {
			log.Println(err)
		}
		email := string(bodyBytes)
		log.Printf("Received search request for \"%v\".", email)
		w.WriteHeader(200)
		userExist := database.EmailExists(email)
		if userExist {
			w.Write([]byte("true"))
		} else {
			w.Write([]byte("false"))
		}
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
	}

}
func HandleInvite(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		bodyBytes, err := io.ReadAll(r.Body)
		defer r.Body.Close()
		if err != nil {
			log.Println(err)
		}
		body := string(bodyBytes)
		splittedBody := strings.Split(body, " ")
		log.Printf("Received friend invite request to \"%v\" from \"%v\".", splittedBody[1], splittedBody[0])
		// w.WriteHeader(200)
		database.InsertFriendShip(splittedBody[0], splittedBody[1])
		_, err = w.Write([]byte("invited"))
		if err != nil {
			log.Println(err)
		}
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
	}
}

func DeclineInvitationHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		bodyBytes, err := io.ReadAll(r.Body)
		defer r.Body.Close()
		if err != nil {
			log.Println(err)
		}
		// fmt.Println(string(bodyBytes))
		arr := strings.Split(string(bodyBytes), " ")
		database.DeclineInvitation(arr[0], arr[1])
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
	}
}
func AcceptInvitationHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		bodyBytes, err := io.ReadAll(r.Body)
		defer r.Body.Close()
		if err != nil {
			log.Println(err)
		}
		arr := strings.Split(string(bodyBytes), " ")
		database.AcceptInvitation(arr[0], arr[1])
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
	}
}
func DeleteFriendHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		bodyBytes, err := io.ReadAll(r.Body)
		defer r.Body.Close()
		if err != nil {
			log.Println(err)
		}
		arr := strings.Split(string(bodyBytes), " ")
		database.DeleteFriend(arr[0], arr[1])
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
	}
}

func HandleLastPosition(w http.ResponseWriter, r *http.Request) {
	if r.Method == "POST" {
		bodyBytes, err := io.ReadAll(r.Body)
		defer r.Body.Close()
		if err != nil {
			log.Println(err)
		}
		user := database.GetUserLastPosition(string(bodyBytes))
		json, err := json.Marshal(user)
		if err != nil {
			log.Println(err)
		}
		w.Write(json)
	} else {
		w.WriteHeader(http.StatusMethodNotAllowed)
	}
}
