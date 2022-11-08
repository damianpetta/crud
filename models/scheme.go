package models

import (
	"gorm.io/gorm"
)

type Student struct {
	gorm.Model
	FirstName string `json:"firstname"`
	LastName  string `json:"lastname"`
	Age       int    `json:"age"`
	PhotoImg  string `json:"photo_img"`
}
type User struct {
	UserID   uint   `json:"user_id" gorm:"primarykey"`
	Username string `json:"username"`
	Password string `json:"password"`
	Role     string `json:"role"`
}
type Token struct {
	Uuid      string `json:"uuid" gorm:"primarykey"`
	Token     string `json:"token"`
	TokenType string `json:"token_type"`
	ExpiresAt int64  `json:"expires"`
	UserID    uint   `json:"user_id"`
}

func (s *Student) TableName() string {
	return "students"
}
func (u *User) TableName() string {
	return "users"
}

func (t *Token) TableName() string {
	return "tokens"
}
