package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	file, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(file)

	lineAvailable := scanner.Scan()
	line := scanner.Text()

	directions := line

	//Pass empty line
	lineAvailable = scanner.Scan()
	lineAvailable = scanner.Scan()

	nodes := map[string]Node{}

	for lineAvailable {
		line := scanner.Text()

		//AAA = (BBB, CCC)

		id := line[0:3]
		left := line[7:10]
		right := line[12:15]

		nodes[id] = NewNode(id, left, right)

		lineAvailable = scanner.Scan()
	}
	file.Close()

	thisNodeId := "AAA"
	steps := 0
	found := false
	for !found {
		i := steps % len(directions)
		dir := directions[i]
		node := nodes[thisNodeId]
		if dir == 'L' {
			thisNodeId = node.left
		} else if dir == 'R' {
			thisNodeId = node.right
		} else {
			panic("Invalid direction")
		}
		steps++

		if thisNodeId == "ZZZ" {
			found = true
			break
		}

		if i > 10000 {
			panic("Breaking at 10000 steps")
		}
	}

	fmt.Println(fmt.Sprint(steps) + " steps")

	//pt2

	ghostNodeIds := []string{}
	for _, node := range nodes {
		if node.startingGhostNode {
			ghostNodeIds = append(ghostNodeIds, node.id)
		}
	}

	ghostNodeLoopLengths := map[int]int{}
	ghostNodeLoopExit := map[int]string{}
	ghostNodeLoopCount := map[int]int{}

	steps = 0
	found = false
	for !found {
		i := steps % len(directions)
		dir := directions[i]
		ghostsNotEndNode := 0
		for ghostNodeIndex, ghostNodeId := range ghostNodeIds {
			ghostNode := nodes[ghostNodeId]

			if ghostNode.endingGhostNode {
				if len(ghostNodeLoopExit[ghostNodeIndex]) != 0 && ghostNodeLoopLengths[ghostNodeIndex] == 0 {
					ghostNodeLoopLengths[ghostNodeIndex] = ghostNodeLoopCount[ghostNodeIndex]
				}
				ghostNodeLoopExit[ghostNodeIndex] = ghostNodeId
			}
			if len(ghostNodeLoopExit[ghostNodeIndex]) != 0 && ghostNodeLoopLengths[ghostNodeIndex] == 0 {
				ghostNodeLoopCount[ghostNodeIndex]++
			}

			if dir == 'L' {
				ghostNodeIds[ghostNodeIndex] = ghostNode.left
			} else if dir == 'R' {
				ghostNodeIds[ghostNodeIndex] = ghostNode.right
			} else {
				panic("Invalid direction")
			}
			if !ghostNode.endingGhostNode {
				ghostsNotEndNode++
			}
		}

		if ghostsNotEndNode == 0 {
			found = true
			break
		}

		steps++

		if steps > 1000000000 {
			panic("Breaking at 1000000000 steps")
		}
		if steps%100000000 == 0 {
			fmt.Println(fmt.Sprint(100*steps/1000000000) + "%")
		}

		if len(ghostNodeLoopLengths) == len(ghostNodeIds) {
			fmt.Println("Found ghost loops")
			break
		}
	}

	runningLcm := 1
	for _, val := range ghostNodeLoopLengths {
		runningLcm = LCM(runningLcm, val)
	}

	fmt.Println(fmt.Sprint(runningLcm) + " steps")
}

// nabbed from https://siongui.github.io/2017/06/03/go-find-lcm-by-gcd/
// greatest common divisor (GCD) via Euclidean algorithm
func GCD(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

// find Least Common Multiple (LCM) via GCD
func LCM(a, b int, integers ...int) int {
	result := a * b / GCD(a, b)

	for i := 0; i < len(integers); i++ {
		result = LCM(result, integers[i])
	}

	return result
}
