package models

import "github.com/damianpetta/crud/config"

func ShowALL(s *[]Student) {
	config.DB.Table("students").Select("ID", "first_name", "last_name", "age").Find(&s)
}

func ShowOne(s *Student, id string) {
	config.DB.Table("students").Select("ID", "first_name", "last_name", "age").First(&s, id)
}
