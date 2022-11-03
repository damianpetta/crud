package controllers

import (
	"net/http"

	"github.com/damianpetta/crud/models"
	"github.com/gin-gonic/gin"
)

// @Tags        Frontend
// @Title       Index Page
// @Description Just showing an index page
// @Router      /view/ [get]
func ViewIndex(c *gin.Context) {
	c.HTML(http.StatusOK, "sites/index.html", gin.H{
		"title": "Main website",
	})
}

// @Tags        Frontend
// @Title       Adding Page
// @Description Show a page where you can add a new Student
// @Router      /view/adding/ [get]
func ViewAdd(c *gin.Context) {
	c.HTML(http.StatusOK, "sites/addstudent.html", gin.H{
		"title": "Add student",
	})
}

// @Tags        Frontend
// @Title       Delete Page
// @Description Show a page where you can delete a Student from database
// @Router      /view/deleting/ [get]
func ViewDelete(c *gin.Context) {
	c.HTML(http.StatusOK, "sites/deletestudent.html", gin.H{
		"title": "Delete student",
	})
}

// @Tags        Frontend
// @Title       Update Page
// @Description Show a page where you can update Student data
// @Router      /view/updating/ [get]
func ViewUpdate(c *gin.Context) {
	c.HTML(http.StatusOK, "sites/updatestudent.html", gin.H{
		"title": "Updating Student Data",
	})
}

// @Tags        Frontend
// @Title       Show ALL Page
// @Description Show a page where you can see all students
// @Router      /view/showing [get]
func ViewShowAll(c *gin.Context) {
	var student []models.Student

	models.ShowALL(&student)

	data := gin.H{
		"title":   "Data of students",
		"student": student,
	}

	c.HTML(http.StatusOK, "sites/showing.html", data)

}

// @Tags        Frontend
// @Title       Show ONE Page
// @Description Show a page where you can see all students
// @Router      /view/showing [get]
func ViewShowOne(c *gin.Context) {
	var student *models.Student

	data := gin.H{
		"title":   "Data of students",
		"student": student,
	}

	c.HTML(http.StatusOK, "sites/showingone.html", data)
}
