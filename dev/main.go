package main

import (
	"fmt"

	"github.com/damianpetta/crud/dev/config"
	"github.com/damianpetta/crud/dev/models"
	"github.com/damianpetta/crud/dev/routers"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"

	docs "github.com/damianpetta/crud/dev/docs"
	swaggerfiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

// @BasePath                   /
// @Title                      Simple CRUD API
// @Description                API created to pracite golang skills
// @Scheme                     http
// @Consumes                   application/json
// @Produces                   application/json
// @ContactName                Damian Petta
// @ContactEmail               pettadamian@gmail.com
// @Server                     localhost:8080 Server 1
// @securityDefinitions.apikey BearerAuth
// @in                         header
// @name                       Authorization
// @description                In this version of swagger you must write "Bearer " prefiks before your JWT token "Bearer [your_token]"
var err error

func main() {
	config.DB, err = gorm.Open(sqlite.Open("students.db"), &gorm.Config{})
	if err != nil {
		fmt.Println("status: ", err)
	}
	docs.SwaggerInfo.BasePath = "/"
	config.DB.AutoMigrate(&models.Student{})
	config.DB.AutoMigrate(&models.User{})
	config.DB.AutoMigrate(&models.Token{})
	r := routers.SetupRouter()

	// running
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerfiles.Handler))

	r.Run(":8080")

}
