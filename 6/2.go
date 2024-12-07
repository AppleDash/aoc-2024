package main

import (
	"github.com/hashicorp/go-set/v3"
)

// Simulate the Guard's movement until he gets stuck in a loop,
// or escapes the map.
// Returns false if he escaped the map, true if he gets stuck in a loop.
func compute(input []string) bool {
	positions := set.New[Point](10)

	for point := findGuardStart(input); point.Heading != -1; {
		point = step(input, point)

		if !positions.Insert(point) {
			// We've already been at this point, going this heading.
			// We're caught in a loop!
			return true
		}
	}

	return false
}

func replaceChar(input []string, x int, y int, c byte) {
	bytes := []byte(input[y])
	bytes[x] = c
	input[y] = string(bytes)
}

func main() {
	input, err := loadInput("input.txt")

	if err != nil {
		println("Failed to read input:", err)
		return
	}

	count := 0

	// Try every position for a new obstacle, and count the ones that
	// result in a loop.
	for y := 0; y < len(input); y++ {
		for x := 0; x < len(input[0]); x++ {
			if input[y][x] == '.' {
				replaceChar(input, x, y, '#')
				if compute(input) {
					count += 1
				}
				replaceChar(input, x, y, '.')
			}
		}
	}

	println(count)
}
