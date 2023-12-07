package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	hands := []Hand{}
	for lineAvailable {
		line := scanner.Text()

		split := strings.Split(line, " ")

		hands = append(hands, newHand(split[0], split[1]))

		lineAvailable = scanner.Scan()
	}
	file.Close()

	sort.Slice(hands, func(i int, j int) bool {
		return evaluateHands(hands[i], hands[j]) > 0
	})

	score := 0

	for i, hand := range hands {
		rank := i + 1
		handScore := rank * hand.bid
		score += handScore
		fmt.Println("Hand " + hand.text + " bid " + fmt.Sprint(hand.bid) + " rank " + fmt.Sprint(rank) + " score " + fmt.Sprint(handScore))
	}

	fmt.Println("score: " + strconv.Itoa(score))

}
