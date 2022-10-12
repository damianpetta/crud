package helper

import "github.com/dgrijalva/jwt-go"

// Structy trzymamy w folderze Models pod nazwą np. struct_user.go
// Tutaj powinny być skrypty pomocnicze jak ten, który masz w folderze `response`

type ResponseData struct {
	Status int
	Meta   interface{}
	Data   interface{}
}

type Claims struct {
	UserID     uint   `json:"user_id"`
	Username   string `json:"username"`
	Role       string `json:"role"`
	AccessUuid string `json:"uuid"`
	jwt.StandardClaims
}

type AccessDetails struct {
	UserId     uint64
	Role       string
	AccessUuid string
}

type StudentSwagger struct {
	//Student object swaggger
	FirstName string `json:"firstname" example:"Student1"`
	LastName  string `json:"lastname" example:"Lastname1"`
	Age       int    `json:"age" example:"5"`
} //@name StudentSwagger

type UserSwaggerRegister struct {
	//User object swagger
	Username string `json:"username" example:"User1"`
	Password string `json:"password" example:"Password1"`
	Role     string `json:"role" example:"only admin or developer work"`
} //@name UserSwaggerRegister

type UserSwaggerLogin struct {
	//User object swagger
	Username string `json:"username" example:"User1"`
	Password string `json:"password" example:"Password1"`
} //@name UserSwaggerLogin

type RefreshSwagger struct {
	//Refresh object swagger
	RefreshUuid string `json:"refresh_token" example:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjozLCJ1c2VybmFtZSI6InN0cmluZyIsInJvbGUiOiJoZWxpa29wdGVyIiwidXVpZCI6IjJmNGUwMTkzLTQyNGUtNGRiYS1hY2EwLTFkNDMzYmJjM2Q2NCIsImV4cCI6MTY2NDg5Mzc3Nn0.x8FX7wla5G6xSgxEELc6VjFjY5S9DNohDvg6RCcsqEs"`
} //@name RefreshSwagger
