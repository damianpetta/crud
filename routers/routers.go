package routers

import (
	"github.com/damianpetta/crud/controllers"
	"github.com/damianpetta/crud/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	router := gin.Default()
	router.POST("/register", controllers.CreateUser)
	router.POST("/login", controllers.Login)
	router.POST("/refresh", controllers.Refresh)
	commands := router.Group("student")
	{
		commands.GET("list", controllers.ListOfStudents)
		commands.POST("add/", middleware.AuthMiddlewareAdminOnly(), controllers.AddNewStudent)
		commands.PUT("upd/:id", middleware.AuthMiddleware(), controllers.UpdateStudentData)
		commands.DELETE("del/:id", middleware.AuthMiddlewareAdminOnly(), controllers.DeleteStudent)
		commands.GET("list/:id", controllers.ShowOneStudent)

	}

	return router
}
