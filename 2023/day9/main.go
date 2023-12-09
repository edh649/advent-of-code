package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	sequences := []Sequence{}

	for lineAvailable {
		line := scanner.Text()

		newSeq := NewSequenceFromLine(line)
		sequences = append(sequences, newSeq)

		lineAvailable = scanner.Scan()
	}
	file.Close()

	nextVals := 0
	for _, seq := range sequences {
		nextVal, _ := seq.predictNextValue(1)
		nextVals += nextVal
		// fmt.Println(fmt.Sprint(nextVal) + "  - " + fmt.Sprint(depth))
	}

	fmt.Println(fmt.Sprint(nextVals))

	//pt2
	prevVals := 0
	for _, seq := range sequences {
		slices.Reverse(seq.values)
		prevVal, _ := seq.predictNextValue(1)
		prevVals += prevVal
		// fmt.Println(fmt.Sprint(prevVal) + "  - " + fmt.Sprint(depth))
	}

	fmt.Println(fmt.Sprint(prevVals))
}
