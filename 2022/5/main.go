package main

import (
	"bufio"
	"fmt"
	"io"
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

	fileResults := Parsefile(file, true)

	//REset the pointer back to the start. Again messy
	_, err = file.Seek(0, io.SeekStart)
	if err != nil {
		log.Fatal(err)
	}

	fileResults2 := Parsefile(file, false)

	result := ""
	for i, v := range fileResults.finalStack {
		if i == 0 {
			continue
		}
		result = result + string(v[0])
	}

	result2 := ""
	for i, v := range fileResults2.finalStack {
		if i == 0 {
			continue
		}
		result2 = result2 + string(v[0])
	}

	fmt.Println("Final order: " + result)
	fmt.Println("Final order pt2: " + result2)
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
	finalStack [][]rune
}

func Parsefile(file *os.File, reversePickup bool) fileResult { //asterisk means passed by pointer!
	scanner := bufio.NewScanner(file)

	inSetup := true

	stacks := make([][]rune, 10) //create slice of slice size 10
	for i := 0; i < 10; i++ {
		// looping through the slice to declare
		// slice of slice of length 3
		stacks[i] = make([]rune, 0, 100)
	}

	for scanner.Scan() { // internally, it advances token based on sperator (new line by default)
		strVar := scanner.Text() //get this line of text
		if strVar == "" {
			inSetup = false
			continue
		} else if strVar[:3] == " 1 " {
			inSetup = false
			continue
		}

		if inSetup {
			stackAdditions := SetupStackRow(strVar)
			for i, v := range stackAdditions {
				if v != 0 {
					stacks[i] = append(stacks[i], v)
				}
			}
		} else {
			strSplit := strings.Split(strVar, " ")
			count, _ := strconv.Atoi(strSplit[1])
			stack1, _ := strconv.Atoi(strSplit[3])
			stack2, _ := strconv.Atoi(strSplit[5])

			var taken = make([]rune, count)
			copy(taken, stacks[stack1][:count])
			stacks[stack1] = stacks[stack1][count:]
			if reversePickup {
				reverse(taken)
			}
			toMake := append(taken, stacks[stack2]...) //the ... explodes it or something?
			stacks[stack2] = toMake
		}
	}

	result := fileResult{finalStack: stacks}

	return result
}

func SetupStackRow(row string) []rune {
	itemsToAdd := make([]rune, 10) //actually 9, but leave 0 as a dummy index (makes life easier later)
	for i := 1; i <= 9; i++ {
		strIndexLow := (i - 1) * 4  //0, 4, 8,...
		strIndexHigh := (i * 4) - 1 //4, 8, 12,...
		entry := row[strIndexLow:strIndexHigh]
		trimEntry := strings.Trim(entry, " []")
		if trimEntry != "" {
			itemsToAdd[i] = rune(trimEntry[0])
		}
	}
	return itemsToAdd
}

// https://stackoverflow.com/a/28058324
func reverse[S ~[]E, E any](s S) {
	for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
		s[i], s[j] = s[j], s[i]
	}
}

func assignStack(stack []rune, itemsToFill []rune) {
	for i, v := range itemsToFill {
		stack[i] = v
	}
}
