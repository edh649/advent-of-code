package gardenmap

import (
	"strconv"
	"strings"
)

type ReMap struct {
	SourceStart int

	DestStart int

	Length int
}

type GardenMap struct {
	Source string

	Dest string

	Remap map[int]ReMap
}

func New(source string, dest string) GardenMap {

	e := GardenMap{source, dest, map[int]ReMap{}}
	return e
}

func AddMapping(gardenMap GardenMap, line string) GardenMap {
	remap := gardenMap.Remap

	split := strings.Split(line, " ")
	if len(split) != 3 {
		panic("Space split length not 3")
	}
	sourceStart, _ := strconv.Atoi(split[1])
	destStart, _ := strconv.Atoi(split[0])
	length, _ := strconv.Atoi(split[2])

	remap[sourceStart] = ReMap{sourceStart, destStart, length}

	gardenMap.Remap = remap
	return gardenMap
}

func GetMappedValue(gardenMap GardenMap, value int) int {
	for _, reMapping := range gardenMap.Remap {
		if value >= reMapping.SourceStart && value <= reMapping.SourceStart+reMapping.Length {
			return reMapping.DestStart + (value - reMapping.SourceStart)
		}
	}
	return value
}

func GetInversedMappedValue(gardenMap GardenMap, desiredValue int) int {
	for _, reMapping := range gardenMap.Remap {
		if desiredValue >= reMapping.DestStart && desiredValue <= reMapping.DestStart+reMapping.Length {
			return reMapping.SourceStart + (desiredValue - reMapping.DestStart)
		}
	}
	return desiredValue
}
