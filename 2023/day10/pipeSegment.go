package main

type PipeType int

const (
	NS     PipeType = iota
	EW     PipeType = iota
	NE     PipeType = iota
	NW     PipeType = iota
	SE     PipeType = iota
	SW     PipeType = iota
	Ground PipeType = iota
	Start  PipeType = iota
)

type PipeSegment struct {
	pipeType PipeType

	x int
	y int

	distance int
}

func NewPipeSegment(char rune, x int, y int) PipeSegment {
	pT := Ground
	switch char {
	case '|':
		pT = NS
	case '-':
		pT = EW
	case 'L':
		pT = NE
	case 'J':
		pT = NW
	case '7':
		pT = SE
	case 'F':
		pT = SW
	case '.':
		pT = Ground
	case 'S':
		pT = Start
	default:
		panic("invalid tile character")
	}

	p := PipeSegment{pT, x, y, 0}
	return p
}

func (p PipeSegment) hasConnectionToNorth() bool {
	if p.pipeType == NS || p.pipeType == NE || p.pipeType == NW {
		return true
	}
	return false
}

func (p PipeSegment) hasConnectionToEast() bool {
	if p.pipeType == EW || p.pipeType == NE || p.pipeType == SE {
		return true
	}
	return false
}

func (p PipeSegment) hasConnectionToWest() bool {
	if p.pipeType == EW || p.pipeType == NW || p.pipeType == SW {
		return true
	}
	return false
}

func (p PipeSegment) hasConnectionToSouth() bool {
	if p.pipeType == NS || p.pipeType == SW || p.pipeType == SE {
		return true
	}
	return false
}

func (p PipeSegment) getNextCoordinate(prevX int, prevY int) (int, int) {
	//e.g. 5 from 4, 4-5 = -1. -1 is west
	relativeX := prevX - p.x
	relativeY := prevY - p.y
	return p.getNextCoordinateRelative(relativeX, relativeY)
}

func (p PipeSegment) getNextCoordinateRelative(relX int, relY int) (int, int) {
	return getPipeOutput(p.pipeType, relX, relY)
}

// e.g. NS 0 -1 is a | pipe, entering from -y (N) so return is +y (S) represented as 0, 1
// e.g. EW -1 0 is a - pipe, entering from -x (W) so return is +x (E) represented as 1, 0
func getPipeOutput(pipeType PipeType, inX int, inY int) (int, int) {
	switch pipeType {
	case NS:
		if inX != 0 {
			panic("invalid NS entry")
		}
		return 0, -inY
	case EW:
		if inY != 0 {
			panic("invalid EW entry")
		}
		return -inX, 0
	case NE:
		if inX == 0 && inY == 1 {
			return 1, 0
		}
		if inX == 1 && inY == 0 {
			return 0, 1
		}
		panic("invalid NE entry")
	case NW:
		if inX == 0 && inY == 1 {
			return -1, 0
		}
		if inX == -1 && inY == 0 {
			return 0, -1
		}
		panic("invalid NW entry")
	case SE:
		if inX == 0 && inY == -1 {
			return 1, 0
		}
		if inX == 1 && inY == 0 {
			return 0, -1
		}
		panic("invalid SE entry")
	case SW:
		if inX == 0 && inY == -1 {
			return -1, 0
		}
		if inX == -1 && inY == 0 {
			return 0, 1
		}
		panic("invalid SW entry")
	case Ground:
		panic("Cant get out of ground")
	case Start:
		panic("Found start")
	default:
		panic("invalid pipe type")
	}

}
