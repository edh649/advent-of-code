package main

import (
	"bufio"
	"log"
	"os"
	"sort"
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
	quantities := Parsefile(file)
	quantities = SortValues(quantities)

	println("Max 1 = " + strconv.Itoa(quantities[0]))

	top3 := SumSlice(quantities[:3])
	println("Max 3 = " + strconv.Itoa(top3))
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

func Parsefile(file *os.File) []int { //https://stackoverflow.com/questions/36111777/how-to-read-a-text-file
	scanner := bufio.NewScanner(file)

	var quantities []int //a 'slice'

	var thisCount int = 0
	for scanner.Scan() { // internally, it advances token based on sperator (new line by default)
		strVar := scanner.Text() //get this line of text

		if strVar == "" {
			quantities = append(quantities, thisCount) //appending to a slice
			thisCount = 0
		} else {
			intVar, err := strconv.Atoi(strVar)
			if err != nil {
				log.Fatal(err)
			}
			thisCount = thisCount + intVar
		}
	}

	return quantities
}

func SortValues(intSlice []int) []int { //https://stackoverflow.com/questions/37695209/golang-sort-slice-ascending-or-descending
	sort.Slice(intSlice, func(i, j int) bool {
		return intSlice[i] > intSlice[j]
	})
	return intSlice
}

func SumSlice(intSlice []int) int {
	result := 0
	for _, numb := range intSlice { //use _ when not used (in this case, the index)
		result += numb
	}
	return result
}
