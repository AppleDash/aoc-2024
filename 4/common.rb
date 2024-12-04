DIRECTIONS = [:up, :down, :left, :right, :up_right, :up_left, :down_right, :down_left]
XMAS = 'XMAS'

def load_input(path)
  matrix = []
  File.open(path).each do |line|
    matrix << line.chomp.split('')
  end

  matrix
end

def apply_direction(x, y, dir)
  {
    up: [x, y - 1],
    down: [x, y + 1],
    left: [x - 1, y],
    right: [x + 1, y],
    up_right: [x + 1, y - 1],
    up_left: [x - 1, y - 1],
    down_right: [x + 1, y + 1],
    down_left: [x - 1, y + 1]
  }[dir]
end
