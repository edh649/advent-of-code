package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/edh649/advent-of-code/2023/day6/race"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	scanner.Scan()
	timesText := strings.Split(strings.Trim(strings.Split(scanner.Text(), ":")[1], " "), " ")
	scanner.Scan()
	distancesText := strings.Split(strings.Trim(strings.Split(scanner.Text(), ":")[1], " "), " ")
	file.Close()

	timesFiltered := []int{}
	for _, timeText := range timesText {
		time, err := strconv.Atoi(timeText)
		if err == nil {
			timesFiltered = append(timesFiltered, time)
		}
	}
	distFiltered := []int{}
	for _, distText := range distancesText {
		dist, err := strconv.Atoi(distText)
		if err == nil {
			distFiltered = append(distFiltered, dist)
		}
	}

	raceWaysToWin := 1
	for i := 0; i < len(timesFiltered); i++ {
		raceInst := race.New(timesFiltered[i], distFiltered[i])
		waysToWin := race.CalcWaysToWin(raceInst)
		fmt.Println(fmt.Sprint(waysToWin) + " ways to win in race " + fmt.Sprint(i))
		raceWaysToWin *= waysToWin
	}

	fmt.Println(fmt.Sprint(raceWaysToWin) + " margin of error")

	oneRaceTimeText := strings.ReplaceAll(strings.Join(timesText, ""), " ", "")
	oneRaceDistText := strings.ReplaceAll(strings.Join(distancesText, ""), " ", "")
	oneRaceTime, _ := strconv.Atoi(oneRaceTimeText)
	oneRaceDist, _ := strconv.Atoi(oneRaceDistText)

	raceInst := race.New(oneRaceTime, oneRaceDist)
	waysToWin := race.CalcWaysToWin(raceInst)
	fmt.Println(fmt.Sprint(waysToWin) + " ways to win in long race")

}
