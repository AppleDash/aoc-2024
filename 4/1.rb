require './common'

# Start at the given x, y and look for the character at those coordinates in the matrix.
# If the character is found, recurse until either we go out of bounds, find all the characters,
# or encounter a character along the path that we don't want.
def search_recursive(matrix, x, y, dir, idx)
  # Found the word!
  return true if idx == XMAS.size
  # Out of bounds
  return false if y >= matrix.size || x >= matrix[y].size || y < 0 || x < 0
  # Not the expected character
  return false if matrix[y][x] != XMAS[idx]

  search_recursive(matrix, *apply_direction(x, y, dir), dir, idx + 1)
end

# Start at the given x, y and use a recursive search to find words in every direction.
def search_for_words(matrix, x, y)
  accum = 0
  DIRECTIONS.each do |dir|
    if search_recursive(matrix, x, y, dir, 0)
      accum += 1
    end
  end
  accum
end

matrix = load_input 'input.txt'

# Use the above algorithm on the whole word search matrix.
accum = 0
(0...matrix.size).each do |y|
  (0...matrix[y].size).each do |x|
    accum += search_for_words(matrix, x, y)
  end
end
p accum
