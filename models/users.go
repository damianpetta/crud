package models

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/damianpetta/crud/config"
	"github.com/damianpetta/crud/helper"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"github.com/twinj/uuid"
)

func AddUser(u *User) (err error) {
	if err := config.DB.Create(u).Error; err != nil {
		return err
	}
	return nil
}
func FindUser(gu *User, ud *User) (err error) {
	if err := config.DB.Table("users").Where(&User{Username: gu.Username, Password: gu.Password}).First(&ud).Error; err != nil {
		return err
	}
	return nil
}
func FindUserByID(userid uint64, u *User) (err error) {
	if err := config.DB.Table("users").Where("user_id= ?", userid).First(&u).Error; err != nil {
		return err
	}
	return nil
}
func CreateToken(user_data *User) map[string]string {
	os.Setenv("secret_access", "secret")
	os.Setenv("secret_refresh", "refresh")
	tokens := make(map[string]string)
	expireAccess := time.Now().Add(time.Minute * 15).Unix()
	expireRefresh := time.Now().Add(time.Hour * 1).Unix()
	accessUuid := uuid.NewV4().String()
	refreshUuid := uuid.NewV4().String()
	claimsAccess := &helper.Claims{
		UserID:         user_data.UserID,
		Username:       user_data.Username,
		Role:           user_data.Role,
		AccessUuid:     accessUuid,
		StandardClaims: jwt.StandardClaims{ExpiresAt: expireAccess},
	}

	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claimsAccess)
	accessTokenString, err := accessToken.SignedString([]byte(os.Getenv("secret_access")))
	if err != nil {
		return tokens
	}
	CreateAuth(accessUuid, accessTokenString, "access", expireAccess, user_data.UserID)
	claimsRefresh := &helper.Claims{
		UserID:         user_data.UserID,
		Username:       user_data.Username,
		Role:           user_data.Role,
		AccessUuid:     refreshUuid,
		StandardClaims: jwt.StandardClaims{ExpiresAt: expireRefresh},
	}
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claimsRefresh)
	refreshTokenString, err := refreshToken.SignedString([]byte(os.Getenv("secret_refresh")))
	if err != nil {
		return tokens
	}

	tokens["accessToken"] = accessTokenString
	tokens["refreshToken"] = refreshTokenString
	CreateAuth(refreshUuid, refreshTokenString, "refresh", expireRefresh, user_data.UserID)
	return tokens

}
func CreateAuth(uuid string, tokenstr string, tokentype string, expiretime int64, user_id uint) {
	token := Token{
		Uuid:      uuid,
		Token:     tokenstr,
		TokenType: tokentype,
		ExpiresAt: expiretime,
		UserID:    user_id,
	}

	config.DB.Table("tokens").Create(token)
}
func ExtractToken(r *http.Request) string {
	os.Setenv("secret_access", "secret")
	os.Setenv("secret_refresh", "refresh")
	bearToken := r.Header.Get("Authorization")

	//normally Authorization the_token_xxx
	strArr := strings.Split(bearToken, " ")
	if len(strArr) == 2 {
		return strArr[1]
	}
	return ""
}
func VerifyToken(r *http.Request) (*jwt.Token, error) {
	tokenString := ExtractToken(r)

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		//Make sure that the token method conform to "SigningMethodHMAC"
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(os.Getenv("secret_access")), nil
	})

	if err != nil {
		return nil, err
	}

	return token, nil
}
func TokenValid(r *http.Request) error {
	token, err := VerifyToken(r)
	if err != nil {
		return err
	}

	if _, ok := token.Claims.(jwt.Claims); !ok && !token.Valid {
		var tkn Token
		config.DB.Table("tokens").Where("token = ?", token).First(&tkn)
		DeleteAuth(tkn.Uuid, &tkn)
		return err
	}
	return nil
}
func ExtractTokenMetadata(r *http.Request) (*helper.AccessDetails, error) {
	token, err := VerifyToken(r)

	if err != nil {
		return nil, err
	}
	claims, ok := token.Claims.(jwt.MapClaims)

	if ok && token.Valid {
		role, ok := claims["role"].(string)
		if !ok {
			return nil, err
		}
		userId, err := strconv.ParseUint(fmt.Sprintf("%.f", claims["user_id"]), 10, 64)
		if err != nil {
			return nil, err
		}
		accessUuid, ok := claims["uuid"].(string)
		if !ok {
			return nil, err
		}

		return &helper.AccessDetails{
			Role:       role,
			UserId:     userId,
			AccessUuid: accessUuid,
		}, nil
	}
	return nil, err
}
func DeleteAuth(givenUuid string, t *Token) error {
	config.DB.Table("tokens").Where("uuid = ?", givenUuid).Delete(t)
	return nil

}
func FetchAuth(c *gin.Context, authD *helper.AccessDetails) string {
	var tkn Token
	config.DB.Table("tokens").Where("uuid = ?", authD.AccessUuid).First(&tkn)

	timeNow := time.Now().Unix()
	if tkn.ExpiresAt-timeNow <= 0 {
		DeleteAuth(tkn.Uuid, &tkn)
		c.JSON(http.StatusBadRequest, "token expired please visit /refresh")
		return ""
	}
	return "ok"
}
