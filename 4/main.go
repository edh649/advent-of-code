package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
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

	fileResults := Parsefile(file)
	fmt.Println("Total Overlaps (1): " + strconv.Itoa(fileResults.totalOverlapCount))
	fmt.Println("Partial Overlaps (2): " + strconv.Itoa(fileResults.partialOverlapCount))
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
	totalOverlapCount   int
	partialOverlapCount int
}

func Parsefile(file *os.File) fileResult {
	scanner := bufio.NewScanner(file)

	totalOverlapCount := 0
	partialOverlapCount := 0

	for scanner.Scan() { // internally, it advances token based on sperator (new line by default)
		strVar := scanner.Text() //get this line of text

		row := GetRow(strVar)

		if TotalOverlapCheck(row[0], row[1]) {
			totalOverlapCount += 1
		}

		if PartialOverlapCheck(row[0], row[1]) {
			partialOverlapCount += 1
		}

	}

	result := fileResult{totalOverlapCount: totalOverlapCount, partialOverlapCount: partialOverlapCount}

	return result
}

func GetRow(strVar string) [][]int {
	//convert to values
	entries := strings.Split(strVar, ",")

	one := strings.Split(entries[0], "-")
	two := strings.Split(entries[1], "-")

	oneLow, _ := strconv.Atoi(one[0])
	oneHigh, _ := strconv.Atoi(one[1])
	twoLow, _ := strconv.Atoi(two[0])
	twoHigh, _ := strconv.Atoi(two[1])

	return [][]int{0: []int{oneLow, oneHigh}, 1: []int{twoLow, twoHigh}}
}

func TotalOverlapCheck(one []int, two []int) bool {
	//Check if one in two
	if one[0] >= two[0] && one[1] <= two[1] {
		return true
	}
	//check if two in one
	if two[0] >= one[0] && two[1] <= one[1] {
		return true
	}
	return false
}

func PartialOverlapCheck(one []int, two []int) bool {
	//Check if one in two
	if one[0] >= two[0] && one[0] <= two[1] {
		return true
	}
	//check if two in one
	if two[0] >= one[0] && two[0] <= one[1] {
		return true
	}
	return false
}
