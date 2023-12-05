package gardenmap

import (
	"strconv"
	"strings"
)

type GardenMap struct {
	Source string

	Dest string

	Remap map[int]int
}

func New(source string, dest string) GardenMap {

	e := GardenMap{source, dest, map[int]int{}}
	return e
}

func AddMapping(gardenMap GardenMap, line string) GardenMap {
	remap := gardenMap.Remap

	split := strings.Split(line, " ")
	if len(split) != 3 {
		panic("Space split length not 3")
	}
	sourceStart, _ := strconv.Atoi(split[0])
	destStart, _ := strconv.Atoi(split[1])
	length, _ := strconv.Atoi(split[2])

	for i := 0; i <= length; i++ {
		remap[sourceStart+i] = destStart + i
	}

	gardenMap.Remap = remap
	return gardenMap
}

func GetMappedValue(gardenMap GardenMap, value int) int {
	mappedVal, ok := gardenMap.Remap[value]
	if ok {
		return mappedVal
	}
	return value
}
