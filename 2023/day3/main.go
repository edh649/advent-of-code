package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strconv"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	symbolMap := map[int](map[int]rune){}

	var lineNumber int = 1
	var linePosition int = 0

	for lineAvailable {
		line := scanner.Text()

		linePosition = 1
		symbolMap[lineNumber] = map[int]rune{}
		for _, char := range line {
			symbolMap[lineNumber][linePosition] = char
			linePosition += 1
		}
		symbolMap[lineNumber][0] = '.'            //Add on start to make things easier
		symbolMap[lineNumber][linePosition] = '.' //Add on end to make things easier

		lineNumber += 1
		lineAvailable = scanner.Scan()
	}
	symbolMap[0] = map[int]rune{}
	symbolMap[lineNumber] = map[int]rune{}
	for i, _ := range symbolMap[1] { //Add to top & bottom row to make things easier
		symbolMap[lineNumber][i] = '.'
		symbolMap[0][i] = '.'
	}

	//Setup variables
	var partNumber int = 0
	var isActivePart bool = false
	var activePartSum int = 0

	for lineI := 0; lineI <= len(symbolMap); lineI++ {
		// fmt.Println("")
		// fmt.Println(strconv.Itoa(lineI))
		partNumber = 0
		isActivePart = false
		for linePosI := 0; linePosI <= len(symbolMap[lineI]); linePosI++ {
			// fmt.Print(string(char))
			value := int(symbolMap[lineI][linePosI])
			isPart := false
			if 48 <= value && value <= 57 {
				// Rune is a number
				partNumber = (10 * partNumber) + (value - 48)
				isPart = true
			}
			if isPart && isActivePart == false { //Check for isActivePart
			activePartCheck:
				for _, lineDiff := range []int{-1, 0, 1} {
					for _, posDiff := range []int{-1, 0, 1} {
						adjVal := int(symbolMap[lineI-lineDiff][linePosI-posDiff])
						if (adjVal < 48 || adjVal > 57) && adjVal != 46 {
							//Is a symbol!
							isActivePart = true
							break activePartCheck
						}
					}
				}
			}
			if !(48 <= value && value <= 57) { //Not a number
				if partNumber != 0 {
					if isActivePart == true {
						// fmt.Println("Added part " + strconv.Itoa(partNumber))
						activePartSum += partNumber
					} else {
						fmt.Println("Invalid part " + strconv.Itoa(partNumber))
					}
				}
				isActivePart = false
				partNumber = 0
			}
		}
	}
	fmt.Println("")
	fmt.Println(activePartSum)
	fmt.Println("")

	gearSum := 0
	for lineI := 0; lineI <= len(symbolMap); lineI++ {
		for linePosI := 0; linePosI <= len(symbolMap[lineI]); linePosI++ {
			if symbolMap[lineI][linePosI] == '*' {
				//Look for numbers around
				numbers := []int{}
				numStartIndexes := []int{}
				for _, lineDiff := range []int{-1, 0, 1} {
					lineCheckI := lineI + lineDiff
					for _, posDiff := range []int{-1, 0, 1} {
						adjVal := int(symbolMap[lineCheckI][linePosI+posDiff])
						if adjVal >= 48 && adjVal <= 57 {
							startIndex := (100 * lineCheckI) + (linePosI + posDiff)
							val := adjVal - 48
							//get full number
							if charIsDigit(symbolMap[lineCheckI][linePosI+posDiff-1]) {
								val = val + (10 * (int(symbolMap[lineCheckI][linePosI+posDiff-1]) - 48))
								startIndex -= 1
								if charIsDigit(symbolMap[lineCheckI][linePosI+posDiff-2]) {
									val = val + (100 * (int(symbolMap[lineCheckI][linePosI+posDiff-2]) - 48))
									startIndex -= 1
								}
							}
							if charIsDigit(symbolMap[lineCheckI][linePosI+posDiff+1]) {
								val = (val * 10) + (int(symbolMap[lineCheckI][linePosI+posDiff+1]) - 48)
								if charIsDigit(symbolMap[lineCheckI][linePosI+posDiff+2]) {
									val = (val * 10) + (int(symbolMap[lineCheckI][linePosI+posDiff+2]) - 48)
								}
							}
							if !slices.Contains(numStartIndexes, startIndex) {
								fmt.Println(strconv.Itoa(val))
								numbers = append(numbers, val)
								numStartIndexes = append(numStartIndexes, startIndex)
							}
						}
					}
				}
				if len(numbers) == 2 {
					gearSum += (numbers[0] * numbers[1])
				}
			}
		}
	}
	fmt.Println("")
	fmt.Println(gearSum)

}

func charIsDigit(c rune) bool {
	return c >= 48 && c <= 57
}
