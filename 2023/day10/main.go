package main

import (
	"bufio"
	"os"
)

func main() {
	file, _ := os.Open("test.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	sum := 0

	for lineAvailable {
		line := scanner.Text()

		lineAvailable = scanner.Scan()
	}
	file.Close()
}
