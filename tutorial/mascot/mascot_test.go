package mascot_test

import (
	"testing"

	"github.com/edh649/advent-of-code/tutorial/mascot"
)

func TestMascot(t *testing.T) {
	if mascot.BestMascot() != "Go Gopher" {
		t.Fatal("Wrong Mascot")
	}
}
