import Foundation

struct Point {
  let x: Int
  let y: Int
}

extension Point : Hashable {
  static func == (lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.x)
    hasher.combine(self.y)
  }
}

func gcd(_ a: Int, _ b: Int) -> Int {
    var num1 = a
    var num2 = b

    while num2 != 0 {
        let remainder = num1 % num2
        num1 = num2
        num2 = remainder
    }

    return num1
}

func loadInput() -> [[Character?]] {
  let rawInput : String
  do {
    rawInput = try String(contentsOfFile: "input.txt", encoding: .utf8)
  } catch {
    print("Error loading input: \(error)")
    exit(1)
  }

  return rawInput.split(separator: "\n").map { line in
    line.map { $0 == "." ? nil : $0 }
  }
}

func findAntennas(grid: [[Character?]]) -> [Character: [Point]] {
  var antennas : [Character: [Point]] = [:];

  for (y, row) in grid.enumerated() {
    for (x, c) in row.enumerated() {
      if let freq = c {
        antennas[freq, default: []].append(Point(x: x, y: y))
      }
    }
  }

  return antennas
}

func pointsOnLine(x1: Int, y1: Int, x2: Int, y2: Int, width: Int, height: Int) -> Set<Point> {
    var points = Set<Point>()

    // Find the slope of the line, and the direction we need to step to move.
    let dx = x2 - x1
    let dy = y2 - y1

    let gcdValue = abs(gcd(dx, dy))
    let stepX = dx / gcdValue
    let stepY = dy / gcdValue

    // Add points moving forward
    var x = x1
    var y = y1
    while x >= 0 && y >= 0 && x < width && y < height {
        points.insert(Point(x: x, y: y))
        x += stepX
        y += stepY
    }

    // Add points moving backward
    x = x1
    y = y1
    while x >= 0 && y >= 0 && x < width && y < height {
        points.insert(Point(x: x, y: y))
        x -= stepX
        y -= stepY
    }

    return points
}
