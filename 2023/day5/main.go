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
	file, _ := os.Open("test.txt")
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
			for _, s := range spaceSplitLine {
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

	fmt.Println(gardenmap.GetValue(gardenMapper, 79, "seed", "location"))

	file.Close()
}
