require 'set'

# Class to solve the hiking trails problem by finding trailheads and calculating their scores
class HikingTrails
  def initialize(map)
    # Convert input strings to 2D array of integers
    @map = map.map { |line| line.chars.map(&:to_i) }
    @height = @map.length
    @width = @map[0].length
    # Define possible movement directions: right, down, left, up
    @directions = [[0, 1], [1, 0], [0, -1], [-1, 0]]
  end

  # Main method to calculate the sum of all trailhead scores
  def sum_of_trailhead_scores
    # Find all trailheads (positions with height 0)
    trailheads = find_trailheads
    # Calculate score for each trailhead and sum them
    trailheads.sum { |pos| calculate_trailhead_score(pos) }
  end

  private

  # Find all positions in the map that have height 0
  def find_trailheads
    trailheads = []
    @height.times do |y|
      @width.times do |x|
        trailheads << [y, x] if @map[y][x] == 0
      end
    end
    trailheads
  end

  # Calculate the score for a single trailhead
  # Score is the number of unique height-9 positions reachable via valid hiking trails
  def calculate_trailhead_score(start_pos)
    # Set to store unique reachable height-9 positions
    reachable_nines = Set.new
    # Set to keep track of visited positions to avoid cycles
    visited = Set.new
    # Queue for BFS: each element is [position, path_taken]
    queue = [[start_pos, [@map[start_pos[0]][start_pos[1]]]]]

    # Breadth-first search to find all reachable height-9 positions
    while !queue.empty?
      (pos, path) = queue.shift
      # Skip if we've already visited this position
      next if visited.include?(pos)
      visited.add(pos)

      current_y, current_x = pos
      current_height = @map[current_y][current_x]

      # If we've reached a height-9 position, add it to our set and continue
      if current_height == 9
        reachable_nines.add(pos)
        next
      end

      # Check each possible direction
      @directions.each do |dy, dx|
        new_y = current_y + dy
        new_x = current_x + dx
        
        # Skip if the new position is out of bounds
        next unless in_bounds?(new_y, new_x)
        
        new_height = @map[new_y][new_x]
        
        # Only continue if the height increases by exactly 1
        if new_height == current_height + 1
          # Add the new position and updated path to the queue
          new_path = path + [new_height]
          queue << [[new_y, new_x], new_path]
        end
      end
    end

    # Return the number of unique reachable height-9 positions
    reachable_nines.size
  end

  # Helper method to check if a position is within the map boundaries
  def in_bounds?(y, x)
    y >= 0 && y < @height && x >= 0 && x < @width
  end
end

file_path = "2024/day_ten/input.txt"
input = File.readlines(file_path, chomp: true)

# Create hiking trails object and calculate result
trails = HikingTrails.new(input)
result = trails.sum_of_trailhead_scores

puts "Sum of trailhead scores: #{result}"