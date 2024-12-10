import Foundation

func findAntinodesPart1(antennas: [Point], gridSize: (width: Int, height: Int)) -> Set<Point> {
  var antinodes = Set<Point>();

  for i in 0..<antennas.count {
    for j in (i + 1)..<antennas.count {
      let ant1 = antennas[i]
      let ant2 = antennas[j]

      let dX = ant2.x - ant1.x;
      let dY = ant2.y - ant1.y;

      // Farther antinode
      let fx1 = ant1.x - dX
      let fy1 = ant1.y - dY

      // Closer antinode
      let cx1 = ant2.x + dX
      let cy1 = ant2.y + dY

      // Add valid antinodes within grid
      if fx1 >= 0, fy1 >= 0, fx1 < gridSize.width, fy1 < gridSize.height {
          antinodes.insert(Point(x: fx1, y: fy1))
      }
      if cx1 >= 0, cy1 >= 0, cx1 < gridSize.width, cy1 < gridSize.height {
          antinodes.insert(Point(x: cx1, y: cy1))
      }
    }
  }

  return antinodes
}

func findAntinodesPart2(antennas: [Point], gridSize: (width: Int, height: Int)) -> Set<Point> {
  var antinodes = Set<Point>();

  for i in 0..<antennas.count {
    for j in (i + 1)..<antennas.count {
      let ant1 = antennas[i]
      let ant2 = antennas[j]

      antinodes.formUnion(
        pointsOnLine(x1: ant1.x, y1: ant1.y, x2: ant2.x, y2: ant2.y, width: gridSize.width, height: gridSize.height)
      )
    }
  }

  return antinodes
}

let grid = loadInput()
let antennas = findAntennas(grid: grid);
var antinodesPart1 = Set<Point>();
var antinodesPart2 = Set<Point>()

for (_, antennas) in antennas {
  antinodesPart1.formUnion(findAntinodesPart1(antennas: antennas, gridSize: (width: grid[0].count, height: grid.count)))
  if antennas.count > 1 {
    antinodesPart2.formUnion(findAntinodesPart2(antennas: antennas, gridSize: (width: grid[0].count, height: grid.count)))
  }
}

print(antinodesPart1.count)
print(antinodesPart2.count)
