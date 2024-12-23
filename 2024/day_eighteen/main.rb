#!/usr/bin/env ruby
require 'set'

class MemoryGrid
  attr_reader :corrupted, :size

  def initialize(size = 71)  # Default size for actual puzzle (0 to 70)
    @size = size
    @corrupted = Set.new
  end

  # Add a corrupted position to the grid
  def corrupt_position(x, y)
    @corrupted.add([x, y])
  end

  # Check if a position is valid and not corrupted
  def valid_position?(x, y)
    x >= 0 && x < @size && y >= 0 && y < @size && !@corrupted.include?([x, y])
  end

  # Find shortest path using BFS (Breadth-First Search)
  def find_shortest_path
    start = [0, 0]
    target = [@size - 1, @size - 1]
    
    # Queue will store [x, y, steps] arrays
    queue = [[start[0], start[1], 0]]
    visited = Set.new([start])
    
    # Possible moves: right, down, left, up
    moves = [[0, 1], [1, 0], [0, -1], [-1, 0]]
    
    while !queue.empty?
      x, y, steps = queue.shift
      
      # Return steps if we've reached the target
      return steps if [x, y] == target
      
      # Try each possible move
      moves.each do |dx, dy|
        new_x = x + dx
        new_y = y + dy
        
        if valid_position?(new_x, new_y) && !visited.include?([new_x, new_y])
          visited.add([new_x, new_y])
          queue.push([new_x, new_y, steps + 1])
        end
      end
    end
    
    # If no path is found
    nil
  end

  # Debug method to visualize the grid
  def to_s
    result = ""
    @size.times do |y|
      @size.times do |x|
        result += @corrupted.include?([x, y]) ? '#' : '.'
      end
      result += "\n"
    end
    result
  end
end

def solve(input, byte_limit = 1024)
  # Create grid
  grid = MemoryGrid.new

  # Process input and corrupt positions
  input.strip.split("\n").each_with_index do |line, index|
    break if index >= byte_limit  # Only process first 1024 bytes
    
    x, y = line.strip.split(',').map(&:to_i)
    grid.corrupt_position(x, y)
  end

  # Find shortest path
  grid.find_shortest_path
end

# Main execution
if __FILE__ == $0
  input = File.read(File.join(__dir__, "input.txt"))
  result = solve(input)
  puts result
end
