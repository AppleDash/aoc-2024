package main

import (
	"github.com/hashicorp/go-set/v3"
)

// Simulate the Guard's movement until he escapes the map.
// Returns the number of unique positions he encountered along the way.
func compute(input []string) int {
	positions := set.New[Point](10)
	for point := findGuardStart(input); point.Heading != -1; {
		point = step(input, point)
		positions.Insert(point)
	}

	return positions.Size()
}

func main() {
	input, err := loadInput("input.txt")

	if err != nil {
		println("Failed to read input:", err)
		return
	}

	steps := compute(input)
	println(steps)
}
