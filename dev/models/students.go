package models

import (
	"github.com/damianpetta/crud/dev/config"
	_ "gorm.io/driver/sqlite"
)

func GetAllStudents(s *[]Student) (err error) {
	if err := config.DB.Find(s).Error; err != nil {
		return err
	}
	return nil
}

func AddStudent(s *Student) (err error) {
	if err := config.DB.Create(s).Error; err != nil {
		return err
	}
	return nil
}

func DelStudent(s *Student, id string) (err error) {
	config.DB.Where("id = ?", id).Delete(s)
	return nil
}
func UpdateStudent(sn *Student, s *Student, id string) (err error) {
	config.DB.First(&s, id)

	if err := config.DB.Model(&s).Updates(Student{
		FirstName: sn.FirstName,
		Age:       sn.Age,
		LastName:  sn.LastName,
	}).Error; err != nil {
		return err
	}
	return nil
}
func GetOneStudent(s *Student, id string) (err error) {
	if err := config.DB.First(&s, id).Error; err != nil {
		return err
	}
	return nil

}
