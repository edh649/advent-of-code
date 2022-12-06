package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"unicode/utf8"
)

func main() {
	var err error
	file := OpenFile("input.txt")
	//close the file when done..? messy but fine.
	defer func() { //Defer means it only runs when the function is returned.. interesting
		if err = file.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	result := Parsefile(file)

	fmt.Println("packet index: " + strconv.Itoa(result.packetIndex))
	fmt.Println("message index: " + strconv.Itoa(result.messageIndex))
}

func GetPath() string {
	path, err := os.Getwd() //https://yourbasic.org/golang/current-directory/
	if err != nil {
		log.Println(err)
	}
	return path
}

func OpenFile(filepath string) *os.File { //https://stackoverflow.com/questions/36111777/how-to-read-a-text-file
	file, err := os.Open(filepath)
	if err != nil {
		log.Fatal(err)
	}

	return file
}

type fileResult struct {
	packetIndex  int
	messageIndex int
}

func Parsefile(file *os.File) fileResult { //asterisk means passed by pointer!
	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanRunes)

	packetCount := 4
	messageCount := 14

	buffer := make([]rune, messageCount)

	packetI := 0
	messageI := 0
	currentIndex := 0

	for scanner.Scan() { // internally, it advances token based on sperator (new line by default)
		currentIndex = currentIndex + 1
		r, _ := utf8.DecodeRune(scanner.Bytes()) //https://stackoverflow.com/a/12733444

		for i := messageCount - 1; i > 0; i-- {
			buffer[i] = buffer[i-1]
		}
		buffer[0] = r

		packetFound := true
		messageFound := true

		if buffer[packetCount-1] != 0 && packetI == 0 {
		PACKETSEARCH:
			for i := 0; i < packetCount; i++ {
				for j := 0; j < i; j++ {
					if buffer[i] == buffer[j] {
						packetFound = false
						break PACKETSEARCH
					}
				}
			}
			if packetFound {
				packetI = currentIndex
			}
		}
		if buffer[messageCount-1] != 0 && messageI == 0 {
		MESSAGESEARCH:
			for i := 0; i < messageCount; i++ {
				for j := 0; j < i; j++ {
					if buffer[i] == buffer[j] {
						messageFound = false
						break MESSAGESEARCH
					}
				}
			}
			if messageFound {
				messageI = currentIndex
			}
		}

		if packetI != 0 && messageI != 0 {
			return fileResult{messageIndex: messageI, packetIndex: packetI}
		}
	}

	log.Fatal("reached end of string with no result")
	return fileResult{messageIndex: -1, packetIndex: -1}
}
