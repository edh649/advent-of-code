package main

import (
	"bufio"
	"fmt"
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

		pipes[y] = map[int]PipeSegment{}
		x := -1
		for _, char := range line {
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

	if pipes[startCoordY-1][startCoordX+0].hasConnectionToSouth() {
		nextX = startCoordX
		nextY = startCoordY - 1
	}
	if pipes[startCoordY+0][startCoordX+1].hasConnectionToEast() {
		nextX = startCoordX + 1
		nextY = startCoordY
	}
	if pipes[startCoordY+1][startCoordX+0].hasConnectionToNorth() {
		nextX = startCoordX
		nextY = startCoordY + 1
	}
	if pipes[startCoordY+0][startCoordX-1].hasConnectionToWest() {
		nextX = startCoordX - 1
		nextY = startCoordY
	}

	if nextX == startCoordX && nextY == startCoordY {
		panic("Start has no connections")
	}

	thisTile := pipes[nextY][nextX]
	for depth := 1; depth < 100000; depth++ {
		thisTile = pipes[nextY][nextX]
		thisTile.inLoop = true
		pipes[nextY][nextX] = thisTile
		if(thisTile.pipeType == Start) {
			fmt.Println(fmt.Sprint(depth/2))
			break
		}
		fmt.Println(fmt.Sprint(nextX) + " " + fmt.Sprint(nextY) + " - " + string(thisTile.char))
		nextX, nextY = thisTile.getNextCoordinate(prevX, prevY)
		prevX = thisTile.x
		prevY = thisTile.y
	}
	
	//Part 2 thinking it's something like check how far to the edge, if it's odd then it's not inside?
	
	countInLoop := 0
	for y, _ := range pipes {
		for x, _ := range pipes[y] {
			thisTile = pipes[y][x]
			
			if thisTile.pipeType == Ground {
				inside := true
				loopPassthroughSum := 0
				for lookY := 0; lookY < len(pipes); lookY++ {
					if (lookY == y) {
						if loopPassthroughSum % 2 != 0 {
							inside = false
						}
						loopPassthroughSum = 0
					} else if(pipes[lookY][x].inLoop) {
						loopPassthroughSum++
					}
				}
				for lookX := 0; lookX < len(pipes[y]); lookX++ {
					if (lookX == x) {
						if loopPassthroughSum % 2 != 0 {
							inside = false
						}
						loopPassthroughSum = 0
					} else if(pipes[y][lookX].inLoop) {
						loopPassthroughSum++
					}
				}
				if (inside) {
					fmt.Println(fmt.Sprint(y) + " " + fmt.Sprint(x) + " is contained in loop")
					countInLoop++
				}
			}
		}
	}
	
	fmt.Println(fmt.Sprint(countInLoop))

	file.Close()
}
