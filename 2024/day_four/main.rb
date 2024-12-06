# Task one: Count occurrences of the word "XMAS" in the grid
def count_xmas(grid)
  rows = grid.size       # Number of rows in the grid
  cols = grid.first.size # Number of columns in the grid
  word = "XMAS"          # Target word to search
  word_length = word.size
  directions = [
    [0, 1],   # Right
    [1, 0],   # Down
    [1, 1],   # Diagonal down-right
    [1, -1],  # Diagonal down-left
    [0, -1],  # Left
    [-1, 0],  # Up
    [-1, -1], # Diagonal up-left
    [-1, 1]   # Diagonal up-right
  ]

  count = 0 # Initialize count of matches

  # Iterate through each cell in the grid
  rows.times do |row|
    cols.times do |col|
      # Check all possible directions from the current cell
      directions.each do |dx, dy|
        match = true # Assume a match initially
        # Check if the word matches in the current direction
        (0...word_length).each do |i|
          x, y = row + i * dx, col + i * dy # Calculate next position
          # Check bounds and character match
          if x < 0 || x >= rows || y < 0 || y >= cols || grid[x][y] != word[i]
            match = false
            break
          end
        end
        count += 1 if match # Increment count if a match is found
      end
    end
  end

  count
end

# Task two: Count occurrences of the "X-MAS" pattern in the grid
def count_x_mas(grid)
  rows = grid.size       # Number of rows in the grid
  cols = grid.first.size # Number of columns in the grid
  count = 0 # Initialize count of matches

  # Iterate through each cell excluding the outermost rows and columns
  (1...(rows - 1)).each do |row|
    (1...(cols - 1)).each do |col|
      # Check for the "X-MAS" pattern:
      # M  S
      #  A
      # M  S
      if grid[row - 1][col - 1] == 'M' && # Top-left M
         grid[row][col - 1] == 'S' &&     # Left S
         grid[row][col] == 'A' &&         # Center A
         grid[row][col + 1] == 'S' &&     # Right S
         grid[row + 1][col - 1] == 'M' && # Bottom-left M
         grid[row + 1][col + 1] == 'M'    # Bottom-right M
        count += 1
      end
    end
  end

  count
end

# Read input file and parse the grid
file_path = "day_four/input.txt" # Path to the input file
grid = File.readlines(file_path, chomp: true).map(&:chars) # Read and convert lines to character arrays

# Task One: Count total occurrences of "XMAS"
xmas_count = count_xmas(grid)
puts "Total occurrences of XMAS: #{xmas_count}"

# Task Two: Count total occurrences of "X-MAS"
x_mas_count = count_x_mas(grid)
puts "Total occurrences of X-MAS: #{x_mas_count}"
