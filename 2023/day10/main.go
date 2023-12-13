package main

import (
	"bufio"
	"os"
)

func main() {
	file, _ := os.Open("test_simple.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()

	pipes := make(map[int]map[int]PipeSegment)

	startCoordX := 0
	startCoordY := 0

	y := -1
	for lineAvailable {
		y++
		line := scanner.Text()

		x := -1
		for _, char := range line {
			pipes[y] = map[int]PipeSegment{}
			x++

			pipes[y][x] = NewPipeSegment(char, x, y)

			if char == 'S' {
				startCoordX = x
				startCoordY = y
			}
		}

		lineAvailable = scanner.Scan()
	}

	//Look for pipes around S
	prevX := startCoordX
	prevY := startCoordY
	nextX := startCoordX
	nextY := startCoordY

	if pipes[startCoordX+0][startCoordY-1].hasConnectionToSouth() {
		nextX = startCoordX
		nextY = startCoordY - 1
	}
	if pipes[startCoordX+1][startCoordY+0].hasConnectionToEast() {
		nextX = startCoordX + 1
		nextY = startCoordY
	}
	if pipes[startCoordX+0][startCoordY+1].hasConnectionToNorth() {
		nextX = startCoordX
		nextY = startCoordY + 1
	}
	if pipes[startCoordX-1][startCoordY+0].hasConnectionToWest() {
		nextX = startCoordX - 1
		nextY = startCoordY
	}

	if nextX == startCoordX && nextY == startCoordY {
		panic("Start has no connections")
	}

	for depth := 0; depth < 10000; depth++ {
		thisTile := pipes[nextY][nextX]
		nextX, nextY = thisTile.getNextCoordinate(prevX, prevY)
		prevX = thisTile.x
		prevY = thisTile.y
	}

	file.Close()
}
