package models

type User struct {
	Id        int    `json:"id"`
	Email     string `json:"email"`
	Latitude  string `json:"latitude"`
	Longitude string `json:"longitude"`
}
