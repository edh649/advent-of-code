package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
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
	result := SumSlice(fileResults.duplicatedValues)
	fmt.Println("Duplicated values (1): " + strconv.Itoa(result))
	tokenResult := SumSlice(fileResults.tokenValues)
	fmt.Println("Tokens (2): " + strconv.Itoa(tokenResult))
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
	duplicatedValues []int
	tokenValues      []int
}

func Parsefile(file *os.File) fileResult {
	scanner := bufio.NewScanner(file)

	var values []int
	var tokens []int

	var groupEntries []string
	i := 0
	for scanner.Scan() { // internally, it advances token based on sperator (new line by default)
		strVar := scanner.Text() //get this line of text

		values = append(values, CalculateRow(strVar))
		groupEntries = append(groupEntries, strVar)

		i = i + 1
		if i == 3 {
			token := GetDuplicates([]rune(groupEntries[0]), GetDuplicates([]rune(groupEntries[1]), []rune(groupEntries[2])))[0]
			tokenVal := GetItemValue(token)
			tokens = append(tokens, tokenVal)
			i = 0
			groupEntries = nil
		}
	}

	result := fileResult{duplicatedValues: values, tokenValues: tokens}

	return result
}

func CalculateRow(strVar string) int {
	//convert to values
	compartment1 := []rune(strVar[0 : len(strVar)/2])
	compartment2 := []rune(strVar[len(strVar)/2:])
	duplicatedEntry := GetDuplicates(compartment1, compartment2)[0]
	duplicatedValue := GetItemValue(duplicatedEntry)
	return duplicatedValue
}

func GetItemValue(char rune) int {
	if 97 <= char && char <= 122 {
		return int(char) - 96 // a (97) = 1
	} else {
		return (int(char) - 65) + 27 // A (65) = 27
	}
}

// Using a basic O(n*n) comarison for now. should be fine for this use case. could hash map in future
// https://github.com/juliangruber/go-intersect/blob/master/intersect.go
func GetDuplicates[T comparable](a []T, b []T) []T {
	set := make([]T, 0)

	for _, v := range a {
		if containsGeneric(b, v) {
			set = append(set, v)
		}
	}

	return set
}
func containsGeneric[T comparable](b []T, e T) bool {
	for _, v := range b {
		if v == e {
			return true
		}
	}
	return false
}

func SumSlice(intSlice []int) int {
	result := 0
	for _, numb := range intSlice { //use _ when not used (in this case, the index)
		result += numb
	}
	return result
}
