package controllers

import (
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/damianpetta/crud/dev/models"
	"github.com/damianpetta/crud/dev/response"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

// @Tags        User
// @Title       Add new User
// @Accept      json
// @Description Take create user request and creates an user
// @Router      /register [post]
// @Param       User body helper.UserSwaggerRegister true "Enter a user data"
func CreateUser(c *gin.Context) {
	var user models.User
	c.BindJSON(&user)

	if err := models.AddUser(&user); err != nil {
		response.RespondJSON(c, 404, user)
	} else {
		response.RespondJSON(c, 200, user)
	}
}

// @Tags        User
// @Title       Login to user account
// @Accept      json
// @Description Login
// @Router      /login [post]
// @Param       User body helper.UserSwaggerLogin true "Enter a user data"
func Login(c *gin.Context) {
	var given_data models.User
	var user_data models.User
	c.BindJSON(&given_data)
	models.FindUser(&given_data, &user_data)

	if user_data.UserID == 0 {
		response.RespondJSON(c, 404, "User not found")
		return
	}
	tokens := models.CreateToken(&user_data)

	c.JSON(200, tokens)
}

// @Tags        User
// @Title       Create a new access and refresh token if refresh token is still valid
// @Accept      json
// @Description Refresh
// @Router      /refresh [post]
// @Param       Refresh body helper.RefreshSwagger true "Enter a refresh_token"
func Refresh(c *gin.Context) {
	os.Setenv("secret_access", "secret")
	os.Setenv("secret_refresh", "refresh")
	var tokenm models.Token
	var user models.User
	mapToken := map[string]string{}
	if err := c.ShouldBindJSON(&mapToken); err != nil {
		c.JSON(http.StatusUnprocessableEntity, err.Error())
		return
	}
	refreshToken := mapToken["refresh_token"]

	token, err := jwt.Parse(refreshToken, func(token *jwt.Token) (interface{}, error) {

		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(os.Getenv("secret_refresh")), nil
	})

	if err != nil {
		c.JSON(http.StatusUnauthorized, "Refresh token expired")
		return
	}
	//is token valid?
	if _, ok := token.Claims.(jwt.Claims); !ok && !token.Valid {
		c.JSON(http.StatusUnauthorized, err)
		return
	}
	//Since token is valid, get the uuid:
	claims, ok := token.Claims.(jwt.MapClaims) //the token claims should conform to MapClaims
	if ok && token.Valid {
		refreshUuid, ok := claims["uuid"].(string) //convert the interface to string
		if !ok {
			c.JSON(http.StatusUnprocessableEntity, err)
			return
		}
		userId, err := strconv.ParseUint(fmt.Sprintf("%.f", claims["user_id"]), 10, 64)
		if err != nil {
			c.JSON(http.StatusUnprocessableEntity, "Error occurred")
			return
		}
		//Delete the previous Refresh Token
		delErr := models.DeleteAuth(refreshUuid, &tokenm)
		if delErr != nil { //if any goes wrong
			c.JSON(http.StatusUnauthorized, "unauthorized")
			return
		}
		//Create new pairs of refresh and access tokens
		models.FindUserByID(userId, &user)
		if user.UserID == 0 {
			c.JSON(http.StatusBadRequest, "user dont exist")
		} else {
			tokens := models.CreateToken(&user)
			c.JSON(http.StatusCreated, tokens)
		}

	} else {
		c.JSON(http.StatusUnauthorized, "refresh expired")
	}
}
