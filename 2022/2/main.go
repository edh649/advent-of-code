package main

import (
	"bufio"
	"io"
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

	score1 := Parsefile(file, false)
	println("Strategy 1: " + strconv.Itoa(score1))

	//REset the pointer back to the start. Again messy
	_, err = file.Seek(0, io.SeekStart)
	if err != nil {
		log.Fatal(err)
	}

	score2 := Parsefile(file, true)
	println("Strategy 2: " + strconv.Itoa(score2))
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

func Parsefile(file *os.File, secondStrategy bool) int {
	scanner := bufio.NewScanner(file)

	var score int

	for scanner.Scan() { // internally, it advances token based on sperator (new line by default)
		strVar := scanner.Text() //get this line of text

		if secondStrategy {
			score = score + ScoreStrategy2Lookup(strVar)
		} else {
			score = score + ScoreStrategy1Lookup(strVar)
		}
	}

	return score
}

func ScoreStrategy1Lookup(round_strategy string) int {
	//1 for rock, 2 for paper, 3 for scissors
	shapeScoreMap := map[string]int{"X": 1, "Y": 2, "Z": 3}

	//0 for loss, 3 for draw, 6 for win
	winLossMap := map[string]map[string]int{
		"A": {"X": 3, "Y": 6, "Z": 0},
		"B": {"X": 0, "Y": 3, "Z": 6},
		"C": {"X": 6, "Y": 0, "Z": 3}}

	shapeScore := shapeScoreMap[round_strategy[2:3]]
	winLossScore := winLossMap[round_strategy[:1]][round_strategy[2:3]]

	return shapeScore + winLossScore
}

func ScoreStrategy2Lookup(round_strategy string) int {

	//desiredPickMap. //X is lose, Y is draw, Z is win
	pickMap := map[string]map[string]string{
		"A": {"X": "Z", "Y": "X", "Z": "Y"},
		"B": {"X": "X", "Y": "Y", "Z": "Z"},
		"C": {"X": "Y", "Y": "Z", "Z": "X"}}

	//1 for rock, 2 for paper, 3 for scissors
	shapeScoreMap := map[string]int{"X": 1, "Y": 2, "Z": 3}

	//0 for loss, 3 for draw, 6 for win
	winLossMap := map[string]map[string]int{
		"A": {"X": 3, "Y": 6, "Z": 0},
		"B": {"X": 0, "Y": 3, "Z": 6},
		"C": {"X": 6, "Y": 0, "Z": 3}}

	shouldPick := pickMap[round_strategy[:1]][round_strategy[2:3]]

	shapeScore := shapeScoreMap[shouldPick]
	winLossScore := winLossMap[round_strategy[:1]][shouldPick]

	return shapeScore + winLossScore
}
