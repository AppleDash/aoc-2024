package main

import (
	"io/ioutil"
	"strings"
)

// Represented in the order such that incrementing them turns right.
const (
	Up    = iota
	Right = iota
	Down  = iota
	Left  = iota
)

type Point struct {
	X       int
	Y       int
	Heading int
}

func rotateRight(heading int) (newHeading int) {
	newHeading = heading + 1

	if newHeading > Left {
		newHeading = Up
	}

	return
}

func loadInput(path string) (input []string, err error) {
	rawContent, err := ioutil.ReadFile("input.txt")

	if err != nil {
		return nil, err
	}

	input = strings.Split(string(rawContent), "\n")

	return
}

func findGuardStart(input []string) Point {
	for y, line := range input {
		if x := strings.Index(line, "^"); x != -1 {
			return Point{x, y, Up}
		}
	}

	return Point{-1, -1, -1}
}

// This function only works with ASCII, but the input is ASCII,
// so it's alright in this case.
func getAt(input []string, point Point) byte {
	if point.Y < 0 || point.Y >= len(input) {
		return 0
	}

	row := input[point.Y]

	if point.X < 0 || point.X >= len(row) {
		return 0
	}

	return row[point.X]
}

func moveForward(input []string, point Point) (newPoint Point) {
	newPoint = point
	switch point.Heading {
	case Up:
		newPoint.Y--
		// newPoint = Point{point.X, point.Y - 1, point.Heading}
	case Right:
		newPoint.X++
	case Down:
		newPoint.Y++
	case Left:
		newPoint.X--
	}

	return
}

// Detect the character in the input, in front of the Guard at x, y, and facing heading.
// Returns the character in front of the Guard.
func detectForward(input []string, point Point) byte {
	newPoint := moveForward(input, point)

	return getAt(input, newPoint)
}

// Make one "step" of the Guard's movement. This will move him one position away in the board,
// and possibily rotate him.
func step(input []string, point Point) Point {
	c := detectForward(input, point)

	switch c {
	case 0:
		point.Heading = -1 // Left the map!
	case '#':
		point.Heading = rotateRight(point.Heading)
	default:
		point = moveForward(input, point)
	}

	return point
}
