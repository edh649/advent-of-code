package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	part1()
	part2()
}

func part1() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	winCount := 0

	for lineAvailable {
		line := scanner.Text()

		valid := strings.Split(line, ":")[1]
		split := strings.Split(valid, "|")
		scratched := strings.ReplaceAll(split[1]+" ", " ", "  ")

		winningNums := strings.Trim(strings.ReplaceAll(split[0], "  ", " "), " ")
		winRegex := regexp.MustCompile("(\\s" + strings.ReplaceAll(winningNums, " ", "\\s)|(\\s") + "\\s)")

		wins := winRegex.FindAllString(scratched, -1)
		if len(wins) > 0 {
			score := 1 * math.Pow(2, float64(len(wins)-1))
			// fmt.Println(strconv.Itoa(int(score)))
			winCount += int(score)
		}

		lineAvailable = scanner.Scan()
	}

	fmt.Println(winCount)
	file.Close()
}

func part2() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	//generate win match map
	cardWinMatch := map[int]int{}
	for lineAvailable {
		line := scanner.Text()

		valid := strings.Split(line, ":")[1]
		preCard := strings.Split(line, ":")[0]
		preCardSplit := strings.Split(preCard, " ")
		id, _ := strconv.Atoi(preCardSplit[len(preCardSplit)-1])
		split := strings.Split(valid, "|")
		scratched := strings.ReplaceAll(split[1]+" ", " ", "  ")

		winningNums := strings.Trim(strings.ReplaceAll(split[0], "  ", " "), " ")
		winRegex := regexp.MustCompile("(\\s" + strings.ReplaceAll(winningNums, " ", "\\s)|(\\s") + "\\s)")

		wins := winRegex.FindAllString(scratched, -1)

		cardWinMatch[id] = len(wins)

		lineAvailable = scanner.Scan()
	}

	cardsHeld := 0 //len(cardWinMatch)

	//Now recurse away
	for i := 1; i <= len(cardWinMatch); i++ {
		cardsHeld += getCardsWonById(i, cardWinMatch)
	}

	fmt.Println(cardsHeld)
	file.Close()
}

func getCardsWonById(id int, cardWinMatch map[int]int) int {
	cardCount := 1
	cardsWon := cardWinMatch[id]
	for i := id + 1; i <= (id + cardsWon); i++ {
		cardCount += getCardsWonById(i, cardWinMatch)
	}
	return cardCount
}
