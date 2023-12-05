package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/edh649/advent-of-code/2023/day5/gardenmap"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()
	i := 0

	var seeds []int

	var currentMap gardenmap.GardenMap

	gardenMapper := gardenmap.GardenMapper{}

	for lineAvailable {
		line := scanner.Text()

		spaceSplitLine := strings.Split(line, " ")

		if len(line) < 2 {
		} else if len(line) >= 7 && line[0:7] == "seeds: " {
			for _, s := range spaceSplitLine[1:] {
				seedInt, _ := strconv.Atoi(s)
				seeds = append(seeds, seedInt)
			}
		} else if line[len(line)-5:] == " map:" { //e.g. seed-to-soil map:
			if i > 4 { //Past the first map, so we need to save the old one
				gardenMapper = gardenmap.AppendGardenMap(gardenMapper, currentMap)
			}
			sourceDest := strings.Split(spaceSplitLine[0], "-")

			currentMap = gardenmap.New(sourceDest[0], sourceDest[2])
		} else {
			currentMap = gardenmap.AddMapping(currentMap, line)
		}

		lineAvailable = scanner.Scan()
		i += 1
	}
	gardenMapper = gardenmap.AppendGardenMap(gardenMapper, currentMap)

	smallestSeed := -1
	largestSeed := -1
	part2Seeds := map[int]int{}
	initial := 0
	for _, s := range seeds {
		if s < smallestSeed || smallestSeed == -1 {
			smallestSeed = s
		}
		if s > largestSeed {
			largestSeed = s
		}
		if initial == 0 {
			initial = s
		} else {
			part2Seeds[initial] = s
			initial = 0
		}
	}

	smallest := -1

	for _, seed := range seeds {
		loc := gardenmap.GetValue(gardenMapper, seed, "seed", "location")
		// fmt.Println(strconv.Itoa(seed) + " -> " + strconv.Itoa(loc))
		if loc < smallest || smallest == -1 {
			smallest = loc
		}
	}

	fmt.Println("Min (pt1): " + strconv.Itoa(smallest))

	totalToCheck := smallest * 10
seedCheckLoop:
	for i = 1; i < totalToCheck; i++ {
		requiredSeed := gardenmap.GetInverseValue(gardenMapper, i, "seed", "location")

		if i%1000000 == 0 {
			fmt.Println(fmt.Sprint(100*i/totalToCheck) + "%")
		}

		if i == smallest {
			fmt.Println("passed smallest")
		}

		if requiredSeed > smallestSeed && requiredSeed < largestSeed {
			for seedCheck, length := range part2Seeds {
				if requiredSeed >= seedCheck && requiredSeed <= (seedCheck+length) {
					fmt.Println("Location " + strconv.Itoa(i) + " for seed " + strconv.Itoa(requiredSeed))
					break seedCheckLoop
				}
			}
		}
	}

	file.Close()
}
