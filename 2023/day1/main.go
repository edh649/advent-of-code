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
	find(false) //one
	find(true)  //two
}

func find(replaceTextWithDigits bool) {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	sum := 0

	for lineAvailable {
		line := scanner.Text()

		if replaceTextWithDigits {
			line = strings.ReplaceAll(line, "one", "o1e")
			line = strings.ReplaceAll(line, "two", "t2o")
			line = strings.ReplaceAll(line, "three", "t3e")
			line = strings.ReplaceAll(line, "four", "f4r")
			line = strings.ReplaceAll(line, "five", "f5e")
			line = strings.ReplaceAll(line, "six", "s6x")
			line = strings.ReplaceAll(line, "seven", "s7n")
			line = strings.ReplaceAll(line, "eight", "e8t")
			line = strings.ReplaceAll(line, "nine", "n9e")
		}

		re := regexp.MustCompile("[0-9]")
		digits := re.FindAllString(line, -1)

		digit, _ := strconv.Atoi(digits[0] + digits[len(digits)-1])

		sum += digit

		lineAvailable = scanner.Scan()
	}

	fmt.Println("Total: " + strconv.Itoa(sum))

	file.Close()
}
