package main

import (
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	e := echo.New()

	e.Use(middleware.Logger())

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Wow你居然发现我了！")
	})

	e.GET("/alert/:bot/:cid/:msg", func(c echo.Context) error {
		bot := c.Param("bot")
		cid := c.Param("cid")
		msg := c.Param("msg")

		retMsg := "-"
		if sendMessageByBot(bot, cid, msg) {
			retMsg = "T"
		} else {
			retMsg = "F"
		}

		return c.String(http.StatusOK, retMsg)
	})

	e.Logger.Fatal(e.Start("0.0.0.0:45678"))

}

func sendMessageByBot(bot, cid, msg string) bool {

	url := "https://api.telegram.org/bot" + bot + "/sendMessage?chat_id=" + cid + "&text=" + msg
	fmt.Println("Ready to request: " + url)
	resp, err := http.Get(url)
	if err != nil {
		fmt.Println("Http request error.")
		return false
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Read response error.")
		return false
	}

	fmt.Println(string(body))

	if resp.StatusCode == 200 {
		return true
	} else {
		fmt.Println("Fail")
		return false
	}
}
