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

func evaluateHands(a Hand, b Hand, jWilds ...bool) comparisonResult {
	//default value for jWild
	jWild := false
	if len(jWilds) > 0 {
		jWild = jWilds[0]
	}

	scoreComp := a.handTypeScore(jWild) - b.handTypeScore(jWild)
	if scoreComp > 0 { //a is higher
		return -1
	}
	if scoreComp < 0 { //b is higher
		return 1
	}
	for i := 0; i < 5; i++ {
		if a.cards[i] != b.cards[i] {
			if jWild {
				//If a is a J (11), then it loses.
				if a.cards[i] == 11 {
					return 1
				}
				if b.cards[i] == 11 {
					return -1
				}
			}
			if a.cards[i] > b.cards[i] {
				return -1
			}
			return 1
		}
	}
	return 0
}

func (h Hand) handTypeScore(jWild bool) int {
	baseScore := scoreHand(h.cards)
	if !jWild {
		return baseScore
	}

	jWildMatrix := map[int]map[int]int{
		0: {},
		1: {
			1: 2, // ABCDJ = 1 		= 1 -> p	= 2
			2: 4, // ABCCJ = p 		= 2 -> 3oac = 4
			3: 5, // AACCJ = 2p 	= 3 -> FH 	= 5
			4: 6, // ACCCJ = 3oac	= 4 -> 4oac	= 6
			6: 7, // CCCCJ = 4oac	= 6 -> 5oac = 7
		},
		2: {
			2: 4, // ABCJJ = p 		= 2 -> 3oac	= 4
			3: 6, // ACCJJ = 2p 	= 3 -> 4oac	= 6
			5: 7, // CCCJJ = FH 	= 5 -> 5oac	= 7
		},
		3: {
			4: 6, // ACJJJ = 3oac	= 4 -> 4oac = 6
			5: 7, // CCJJJ = FH 	= 5 -> 5oac = 7
		},
		4: {
			6: 7, // CJJJJ = 4oac	= 6 -> 5oac = 7
		},
		5: {
			7: 7, // JJJJJ = 5oac	= 7 -> 5oac = 7
		},
	}

	numJs := 0
	for _, v := range h.cards {
		if v == 11 {
			numJs++
		}
	}

	jHandMatrix, ok := jWildMatrix[numJs]
	if !ok {
		panic("Not ok")
	}
	newScore, ok := jHandMatrix[baseScore]
	if !ok {
		return baseScore
	}
	return newScore
}

func scoreHand(cards []int) int {
	cardCounts := map[int]int{}

	maxCount := 0
	for _, card := range cards {
		_, ok := cardCounts[card]
		if ok {
			cardCounts[card]++
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
		return 2 //one pair
	}
	if maxCount == 1 {
		return 1
	}
	panic("No score?!")
}
