package main

type PipeType int

const (
	NS PipeType = iota
	EW PipeType = iota
	NE PipeType = iota
	NW PipeType = iota
	SE PipeType = iota
	SW PipeType = iota
	Ground PipeType = iota
	Start PipeType = iota
)

type PipeSegment struct {
	pipeType PipeType
	
	x int
	y int
	
	distance int
	
	inLoop bool
}

func (p PipeSegment) getNextCoordinate(prevX int, prevY int) (int, int) {
	return 1, 2
}

func (p PipeSegment) getNextCoordinateRelative(relX int, relY int) (int, int) {
	return 1, 1
}

// e.g. NS 0 -1 is a | pipe, entering from -y (S) so return is +y (N) represented as 0, 1
func getPipeOutput(pipeType PipeType, inX int, inY int) (int, int) {
	switch pipeType {
		case NS:
			if (inX != 0) {
				panic("invalid NS entry")
			}
			return 0, -inY
		case EW:
			if (inY != 0) {
				panic("invalid EW entry")
			}
			return -inX, 0
		case NE:
			if (inX == 0 && inY == 1) {
				return 1, 0
			}
			return 0, 1
		case NW:
			if (inX == 0 && inY == 1) {
				return -1, 0
			}
			return 0, -1
		case SE:
			if (inX == 0 && inY == -1) {
				return 1, 0
			}
			return 0, -1
		case SW:
			if (inX == 0 && inY == -1) {
				return -1, 0
			}
			return 0, 1
		case Ground:
			panic("Cant get out of ground")
		case Start:
			panic("Found start")
	}
}