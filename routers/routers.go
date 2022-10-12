package routers

import (
	"github.com/damianpetta/crud/controllers"
	"github.com/damianpetta/crud/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	router := gin.Default()
	router.Static("/css", "./sites/css")
	router.LoadHTMLGlob("sites/*.html")
	router.POST("/register", controllers.CreateUser)
	router.POST("/login", controllers.Login)
	router.POST("/refresh", controllers.Refresh)
	commands := router.Group("student")
	{
		commands.GET("list", controllers.ListOfStudents)
		// Nie rozumiem po co przy każdym endpoincie piszesz co robi.
		// Do odróżniania co robi endpoint służą nam polecenia POST, PUT, DELETE

		// Wolę coś takiego :) I proszę tak zrobić w reszcie endpointów
		commands.POST("", middleware.AuthMiddlewareAdminOnly(), controllers.AddNewStudent)
		commands.PUT("/:id", middleware.AuthMiddleware(), controllers.UpdateStudentData)
		commands.DELETE("/:id", middleware.AuthMiddlewareAdminOnly(), controllers.DeleteStudent)
		commands.GET("/:id", controllers.ShowOneStudent)

		// commands.POST("add/", middleware.AuthMiddlewareAdminOnly(), controllers.AddNewStudent)
		// commands.PUT("upd/:id", middleware.AuthMiddleware(), controllers.UpdateStudentData)
		// commands.DELETE("del/:id", middleware.AuthMiddlewareAdminOnly(), controllers.DeleteStudent)
		// commands.GET("list/:id", controllers.ShowOneStudent)

	}

	view := router.Group("view")
	{
		view.GET("/", controllers.ViewIndex)
		view.GET("adding", controllers.ViewAdd)
		view.GET("deleting", controllers.ViewDelete)
		view.GET("updating", controllers.ViewUpdate)
		view.GET("showing", controllers.ViewShowAll)
		view.GET("showing/one", controllers.ViewShowOne)

	}
	return router
}
