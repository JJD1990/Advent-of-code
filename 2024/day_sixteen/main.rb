#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

# Parse the input file to extract the maze grid
def parse_maze(input_file)
  input = File.read(input_file)
  maze = input.strip.split("\n").map(&:chars)
  start = nil
  goal = nil

  # Find the start (S) and end (E) positions
  maze.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      start = [x, y] if cell == 'S'
      goal = [x, y] if cell == 'E'
    end
  end

  raise 'Start position (S) not found in the maze.' if start.nil?
  raise 'Goal position (E) not found in the maze.' if goal.nil?

  [maze, start, goal]
end

# Node structure for the priority queue
Node = Struct.new(:position, :facing, :cost)

# Directions with their corresponding changes in coordinates
DIRECTIONS = {
  'E' => [1, 0],
  'S' => [0, 1],
  'W' => [-1, 0],
  'N' => [0, -1]
}.freeze

# Turn costs
TURN_COST = 1000

# A* search algorithm
def find_lowest_cost_path(maze, start, goal)
  width = maze[0].size
  height = maze.size

  # Priority queue for A* (implemented as an array sorted by cost)
  queue = []
  queue.push(Node.new(start, 'E', 0))

  # Visited states
  visited = Set.new

  # A* search loop
  until queue.empty?
    # Sort queue by cost and get the node with the lowest cost
    current_node = queue.sort_by!(&:cost).shift
    current_pos, current_facing, current_cost = current_node.position, current_node.facing, current_node.cost

    # Check if we reached the goal
    return current_cost if current_pos == goal

    # Mark this state as visited
    visited.add([current_pos, current_facing])

    # Explore possible moves
    DIRECTIONS.each do |facing, (dx, dy)|
      next_pos = [current_pos[0] + dx, current_pos[1] + dy]

      # Check if the next position is within bounds and not a wall
      next if next_pos[0] < 0 || next_pos[0] >= width || next_pos[1] < 0 || next_pos[1] >= height
      next if maze[next_pos[1]][next_pos[0]] == '#'

      # Calculate the cost of the move
      move_cost = current_cost + 1 # Moving forward costs 1
      move_cost += TURN_COST unless current_facing == facing # Add turn cost if direction changes

      # Skip if already visited with lower cost
      next if visited.include?([next_pos, facing])

      # Add the new state to the queue
      queue.push(Node.new(next_pos, facing, move_cost))
    end
  end

  # Return an error if no path is found
  raise 'No path to the goal could be found.'
end

# Main function
def solve(input_file)
  maze, start, goal = parse_maze(input_file)
  puts "Start: #{start}, Goal: #{goal}"
  lowest_cost = find_lowest_cost_path(maze, start, goal)
  puts "Lowest cost to reach the goal: #{lowest_cost}"
end

# Execute the solution
solve('2024/day_sixteen/input.txt')
