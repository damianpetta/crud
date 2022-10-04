package controllers

import (
	"github.com/damianpetta/crud/models"
	"github.com/damianpetta/crud/response"
	"github.com/gin-gonic/gin"
	_ "gorm.io/driver/sqlite"
)

// @Tags        Student
// @Title       Show Students
// @Description Take show user request and returns list of all students
// @Router      /student/list [get]
func ListOfStudents(c *gin.Context) {
	var student []models.Student
	if err := models.GetAllStudents(&student); err != nil {
		response.RespondJSON(c, 404, student)
	} else {
		response.RespondJSON(c, 200, student)
	}
}

// @Tags        Student
// @Title       Add new Student
// @Accept      json
// @Description Take create student request and creates an student
// @Router      /student/add/ [post]
// @Param       Student body helper.StudentSwagger true "Enter a student data"
// @Security    BearerAuth
func AddNewStudent(c *gin.Context) {
	var student models.Student
	c.BindJSON(&student)

	if err := models.AddStudent(&student); err != nil {
		response.RespondJSON(c, 404, student)
	} else {
		response.RespondJSON(c, 200, student)
	}
}

// @Tags        Student
// @Title       Delete Student
// @Accept      json
// @Description Take Delete student request and deletes an student
// @Router      /student/del/{id} [delete]
// @Param       id path string true "Enter a student id"
// @Security    BearerAuth
func DeleteStudent(c *gin.Context) {
	var student models.Student
	id := c.Params.ByName("id")
	if err := models.DelStudent(&student, id); err != nil {
		response.RespondJSON(c, 404, student)
	} else {
		response.RespondJSON(c, 200, student)
	}
}

// @Tags        Student
// @Title       Update Student
// @Accept      json
// @Description Take update student request and updates an student data
// @Router      /student/upd/{id} [put]
// @Param       id      path string                true "Enter a student id"
// @Param       Student body helper.StudentSwagger true "Enter a student data"
// @Security    BearerAuth
func UpdateStudentData(c *gin.Context) {
	var student models.Student
	var studentN models.Student

	id := c.Param("id")

	c.Bind(&studentN)
	if err := models.UpdateStudent(&studentN, &student, id); err != nil {
		response.RespondJSON(c, 404, student)
	} else {
		response.RespondJSON(c, 200, student)
	}

}

// @Tags        Student
// @Title       Show One Student
// @Accept      json
// @Description Show data of specific Student
// @Router      /student/list/{id} [get]
// @Param       id path string true "Enter a student id"
func ShowOneStudent(c *gin.Context) {
	var student models.Student
	id := c.Params.ByName("id")
	if err := models.GetOneStudent(&student, id); err != nil {
		response.RespondJSON(c, 404, student)
	} else {
		response.RespondJSON(c, 200, student)
	}
}
