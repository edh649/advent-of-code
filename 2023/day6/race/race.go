package race

type Race struct {
	Time int

	PreviousWinDistance int

	WaysToWin int
}

func New(time int, previousWinDist int) Race {
	race := Race{time, previousWinDist, 0}
	return race
}

func CalcWaysToWin(race Race) int {
	waysToWin := 0
	for i := 0; i < race.Time; i++ {
		score := CalcHoldTimeScore(race.Time, i)
		if score > race.PreviousWinDistance {
			waysToWin += 1
		}
	}
	return waysToWin
}

func CalcHoldTimeScore(raceLength int, holdLength int) int {
	speed := holdLength
	//d=s*t
	distance := speed * (raceLength - holdLength)
	return distance
}
