package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	stage1()
	stage2()
}

func stage1() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	sum := 0

	for lineAvailable {
		line := scanner.Text()

		//Get ID
		gameId := strings.Split(line, ":")
		idStr := strings.Split(gameId[0], " ")[1]
		id, _ := strconv.Atoi(idStr)

		limits := map[string]int{"red": 12, "green": 13, "blue": 14}
		regexes := map[string]*regexp.Regexp{
			"red":   regexp.MustCompile("([0-9][0-9]+\\sred)"),
			"green": regexp.MustCompile("([0-9][0-9]+\\sgreen)"),
			"blue":  regexp.MustCompile("([0-9][0-9]+\\sblue)")}

		lineExceeds := false

	colourLoop:
		for index, limitElement := range limits {
			digits := regexes[index].FindAllString(line, -1)
			for _, digit := range digits {
				val, _ := strconv.Atoi(strings.Split(digit, " ")[0])
				if val > limitElement {
					lineExceeds = true
					break colourLoop
				}
			}
		}

		if lineExceeds == false {
			sum += id
		}

		lineAvailable = scanner.Scan()
	}

	fmt.Println(sum)

	file.Close()
}

func stage2() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	sum := 0

	for lineAvailable {
		line := scanner.Text()

		regexes := map[string]*regexp.Regexp{
			"red":   regexp.MustCompile("([0-9]+\\sred)"),
			"green": regexp.MustCompile("([0-9]+\\sgreen)"),
			"blue":  regexp.MustCompile("([0-9]+\\sblue)")}

		maxDigits := map[string]int{"red": 0, "green": 0, "blue": 0}

		for index, _ := range maxDigits {
			digits := regexes[index].FindAllString(line, -1)
			for _, digit := range digits {
				val, _ := strconv.Atoi(strings.Split(digit, " ")[0])
				if val > maxDigits[index] {
					maxDigits[index] = val
				}
			}
		}

		product := maxDigits["red"] * maxDigits["green"] * maxDigits["blue"]

		sum += product

		lineAvailable = scanner.Scan()
	}

	fmt.Println(sum)

	file.Close()
}
