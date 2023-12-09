package main

import (
	"strconv"
	"strings"
)

type Sequence struct {
	values []int
}

func NewSequenceFromLine(line string) Sequence {
	splits := strings.Split(line, " ")
	values := []int{}
	for _, strVal := range splits {
		intVal, _ := strconv.Atoi(strVal)
		values = append(values, intVal)
	}
	s := Sequence{values}
	return s
}

func (s Sequence) predictNextValue(i int) (int, int) {
	if i > 1000 {
		panic("infinite loop? (1000 deep)")
	}
	if s.values[0] == 0 && s.values[1] == 0 && s.values[len(s.values)-1] == 0 {
		return s.values[len(s.values)-1] + s.sequenceDiff()[len(s.values)-2], i
	}
	subSeq := Sequence{s.sequenceDiff()}
	nextVal, ii := subSeq.predictNextValue(i + 1)
	return s.values[len(s.values)-1] + nextVal, ii
}

func (s Sequence) sequenceDiff() []int {
	difs := []int{}
	for i := 1; i < len(s.values); i++ {
		difs = append(difs, s.values[i]-s.values[i-1])
	}
	return difs
}
