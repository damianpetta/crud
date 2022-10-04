package response

import (
	"fmt"

	"github.com/damianpetta/crud/helper"
	"github.com/gin-gonic/gin"
)

func RespondJSON(c *gin.Context, status int, data interface{}) {
	fmt.Println("status ", status)
	var res helper.ResponseData
	res.Status = status
	res.Data = data
	c.JSON(status, res)
}
