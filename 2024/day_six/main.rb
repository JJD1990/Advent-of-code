require 'set'

# Define the Grid class to encapsulate the guard's movement logic
# This class handles the movement rules for the guard as described in the problem.
class Grid
  attr_reader :cells, :direction, :position, :visited_positions, :visited_states

  # Initialize the grid with the given cells, starting direction, and position.
  def initialize(cells)
    @cells = cells
    @direction = -1i # Start facing up (imaginary unit represents direction)
    @position = cells.find { |_, cell| cell == '^' }.first # Find the starting position of the guard
    @visited_positions = Set[@position] # Track positions visited
    @visited_states = Set[[@position, @direction]] # Track state (position and direction) to detect loops
  end

  # Move the guard to a new position and update visited positions/states
  def move_to(new_position)
    @position = new_position
    @visited_positions << @position
    @visited_states << [@position, @direction]
    'moved'
  end

  # Turn the guard right (90 degrees) by multiplying the direction by 1i
  def turn_right
    @direction *= 1i
    'turned'
  end

  # Perform a single movement step based on the current state
  def move
    next_position = @position + @direction # Calculate the next position based on direction

    # Check if the state has been visited before (indicating a loop)
    return 'loop' if @visited_states.include?([next_position, @direction])

    # Handle the cell type at the next position
    case @cells[next_position]
    when '^', '.'
      move_to(next_position) # Move forward if the cell is open
    when '#'
      turn_right # Turn right if there is an obstacle
    when nil
      'outside_grid' # Stop if the guard moves outside the grid
    end
  end
end

# Parse the input grid from a file and return a hash mapping positions to cell types
# Each position is represented as a complex number (x + yi)
def parse_input(file_path)
  lines = File.readlines(file_path, chomp: true) # Read the file line by line
  lines.flat_map.with_index do |row, y|
    row.chars.map.with_index do |cell, x|
      [(x + y * 1i), cell] # Map each character to its grid position
    end
  end.to_h
end

# Part 1: Count distinct positions visited by the guard before leaving the grid or entering a loop
def part_one(cells)
  grid = Grid.new(cells)
  # Continue moving until the guard either leaves the grid or enters a loop
  nil until %w[loop outside_grid].include?(grid.move)
  grid.visited_positions.count # Return the number of distinct positions visited
end

# Part 2: Count positions that cause a loop when a single obstruction is added
def part_two(cells)
  initial_grid = Grid.new(cells)
  # Simulate the guard's movements for the initial grid
  nil until %w[loop outside_grid].include?(initial_grid.move)

  # Test each visited position (excluding the starting position) by adding an obstruction
  initial_grid.visited_positions.drop(1).count do |position|
    modified_cells = cells.merge(position => '#') # Add an obstruction at the position
    test_grid = Grid.new(modified_cells) # Create a new grid with the obstruction

    # Simulate movements for the modified grid
    nil until %w[loop outside_grid].include?(state = test_grid.move)
    state == 'loop' # Check if the guard enters a loop
  end
end

# Main logic
file_path = 'day_six/input.txt' # Input file path
cells = parse_input(file_path) # Parse the input grid

# Part 1: Calculate the number of distinct positions visited
part_one_result = part_one(cells)
puts "Part 1: #{part_one_result}"

# Part 2: Calculate the number of positions causing a loop
part_two_result = part_two(cells)
puts "Part 2: #{part_two_result}"
