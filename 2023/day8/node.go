package main

type Node struct {
	id string

	left string

	right string

	startingGhostNode bool

	endingGhostNode bool
}

func NewNode(id string, left string, right string) Node {

	var node Node
	if id[2:3] == "A" {
		node = Node{id, left, right, true, false}
	} else if id[2:3] == "Z" {
		node = Node{id, left, right, false, true}
	} else {
		node = Node{id, left, right, false, false}
	}

	return node
}
