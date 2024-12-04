require './common'

# Get the char in the given direction relative to the given x, y in the matrix.
def get_char(matrix, x, y, dir)
  x, y = apply_direction(x, y, dir)
  matrix[x][y]
end

# Look for an "X-MAS" (MAS spelled twice in an X centered on x, y).
def check_neighbors(matrix, x, y)
  up_left = get_char(matrix, x, y, :up_left)
  up_right = get_char(matrix, x, y, :up_right)
  down_left = get_char(matrix, x, y, :down_left)
  down_right = get_char(matrix, x, y, :down_right)

  chars = ['M', 'S']

  valid_chars = [up_left, up_right, down_left, down_right].all? { |c| chars.include? c }

  up_left != down_right && up_right != down_left && valid_chars
end

# Look at every coordinate in the matrix that has a neighbor in every direction,
# and if it's an A, then run the search to look for the X-MAS pattern.
def search(matrix)
  accum = 0
  (1...matrix.size - 1).each do |y|
    (1...matrix[y].size - 1).each do |x|
      if matrix[x][y] == 'A' && check_neighbors(matrix, x, y)
        accum += 1
      end
    end
  end
  accum
end

matrix = load_input 'input.txt'
p search(matrix)
