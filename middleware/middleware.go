package middleware

import (
	"errors"
	"net/http"
	"strings"

	"github.com/damianpetta/crud/models"
	"github.com/damianpetta/crud/response"
	"github.com/gin-gonic/gin"
)

func AuthMiddlewareAdminOnly() gin.HandlerFunc {
	return func(c *gin.Context) {
		err := models.TokenValid(c.Request)
		if err != nil {
			c.JSON(http.StatusUnauthorized, err.Error())
			c.Abort()
			return
		}
		tokenAuth, err := models.ExtractTokenMetadata(c.Request)
		if err != nil {
			c.JSON(http.StatusUnauthorized, "unauthorized")
			c.Abort()
		}
		ok := models.FetchAuth(c, tokenAuth)
		if ok != "ok" {
			c.JSON(http.StatusUnauthorized, err)
			c.Abort()
		}
		if tokenAuth.Role != "admin" {
			c.JSON(http.StatusUnauthorized, "unauthorized")
			c.Abort()
		} else {
			c.Next()
		}
	}
}
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		err := models.TokenValid(c.Request)
		if err != nil {
			c.JSON(http.StatusUnauthorized, err.Error())
			c.Abort()
			return
		}
		tokenAuth, err := models.ExtractTokenMetadata(c.Request)
		if err != nil {
			c.JSON(http.StatusUnauthorized, "unauthorized")
			c.Abort()
		}
		ok := models.FetchAuth(c, tokenAuth)
		if ok != "ok" {
			c.JSON(http.StatusUnauthorized, err)
			c.Abort()
		}
		if tokenAuth.Role == "admin" || tokenAuth.Role == "developer" {

			c.Next()
		} else {
			c.JSON(http.StatusUnauthorized, "unauthorized")
			c.Abort()
		}

	}
}

func AuthMiddlewareTest() gin.HandlerFunc {
	return func(c *gin.Context) {
		authorizationHeader := c.GetHeader("Authorization")
		if len(authorizationHeader) == 0 {
			err := errors.New("please provide authorization header")
			response.RespondJSON(c, http.StatusUnauthorized, err)
			c.Abort()
		}
		fields := strings.Fields(authorizationHeader)
		if len(fields) < 2 {
			err := errors.New("invalid authorization format")
			response.RespondJSON(c, http.StatusUnauthorized, err)
			c.Abort()
		}
		authorizationType := strings.ToLower(fields[0])
		if authorizationType != "bearer" {
			err := errors.New("invalid authorization type")
			response.RespondJSON(c, http.StatusUnauthorized, err)
			c.Abort()
		}
		//accessToken := fields[1]
		payload, err := models.ExtractTokenMetadata(c.Request)
		if err != nil {
			err := errors.New("please provide authorization header")
			response.RespondJSON(c, http.StatusUnauthorized, err)
			c.Abort()
		}

		c.Set("authorization_payload", payload)
		c.Next()

	}
}
