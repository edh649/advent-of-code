package main

import "strconv"

type Hand struct {
	text string

	cards []int

	bid int
}

func runeToCardValue(char rune) int {
	c := map[rune]int{
		'1': 1,
		'2': 2,
		'3': 3,
		'4': 4,
		'5': 5,
		'6': 6,
		'7': 7,
		'8': 8,
		'9': 9,
		'T': 10,
		'J': 11,
		'Q': 12,
		'K': 13,
		'A': 14,
	}

	val, ok := c[char]
	if ok {
		return val
	}
	panic("Unexpected character " + string(char))

}

func newHand(text string, bid string) Hand {
	cards := []int{}
	for _, c := range text {
		cardValue := runeToCardValue(c)
		cards = append(cards, cardValue)
	}
	bidInt, _ := strconv.Atoi(bid)
	h := Hand{text, cards, bidInt}
	return h
}

// comparisonResult is -1 for a better, 0 for equal, 1 for b better
type comparisonResult int

func evaluateHands(a Hand, b Hand) comparisonResult {
	scoreComp := a.handTypeScore() - b.handTypeScore()
	if scoreComp > 0 { //a is higher
		return -1
	}
	if scoreComp < 0 { //b is higher
		return 1
	}
	for i := 0; i < 5; i++ {
		if a.cards[i] != b.cards[i] {
			if a.cards[i] > b.cards[i] {
				return -1
			}
			return 1
		}
	}
	return 0
}

type score struct {
	typeStrength int
	highestCard  int
}

func (h Hand) handTypeScore() int {
	cardCounts := map[int]int{}

	maxCount := 0
	for _, card := range h.cards {
		_, ok := cardCounts[card]
		if ok {
			cardCounts[card] += 1
		} else {
			cardCounts[card] = 1
		}
		if cardCounts[card] > maxCount {
			maxCount = cardCounts[card]
		}
	}

	if maxCount == 5 { // 5 of a kind
		return 7
	}
	if maxCount == 4 { //4 of a kind
		return 6
	}
	if maxCount == 3 { //full house or 3 of a kind
		if len(cardCounts) == 2 { //full house (only 2 types of card)
			return 5
		}
		return 4 //three of a kind
	}
	if maxCount == 2 { //two pair or 1 pair
		if len(cardCounts) == 3 {
			return 3 //two pair (3 cards total. pair, pair, single)
		}
		return 2 //one paid
	}
	if maxCount == 1 {
		return 1
	}
	return 0
}
