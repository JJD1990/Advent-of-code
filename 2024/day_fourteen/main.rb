# Constants for the size of the grid and the number of seconds to simulate
GRID_WIDTH = 101
GRID_HEIGHT = 103
SIMULATION_SECONDS = 100

# Parse the input to extract robot positions and velocities
def parse_input(input)
  input.lines.map do |line|
    # Extract position (p=x,y) and velocity (v=x,y) using regex
    match = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)
    {
      position: [match[1].to_i, match[2].to_i],
      velocity: [match[3].to_i, match[4].to_i]
    }
  end
end

# Simulate the motion of robots for the given number of seconds
def simulate_motion(robots, seconds)
  robots.each do |robot|
    x, y = robot[:position]
    vx, vy = robot[:velocity]

    # Update position with wrapping
    robot[:position] = [
      (x + vx * seconds) % GRID_WIDTH,
      (y + vy * seconds) % GRID_HEIGHT
    ]
  end
end

# Count the number of robots in each quadrant
def calculate_quadrants(robots)
  # Divide the grid into quadrants
  mid_x = GRID_WIDTH / 2
  mid_y = GRID_HEIGHT / 2

  # Initialize counts for each quadrant
  quadrants = [0, 0, 0, 0] # Top-left, Top-right, Bottom-left, Bottom-right

  robots.each do |robot|
    x, y = robot[:position]

    # Skip robots in the middle row/column
    next if x == mid_x || y == mid_y

    # Determine the quadrant
    if x < mid_x && y < mid_y
      quadrants[0] += 1 # Top-left
    elsif x >= mid_x && y < mid_y
      quadrants[1] += 1 # Top-right
    elsif x < mid_x && y >= mid_y
      quadrants[2] += 1 # Bottom-left
    elsif x >= mid_x && y >= mid_y
      quadrants[3] += 1 # Bottom-right
    end
  end

  quadrants
end

# Compute the safety factor by multiplying the counts in all quadrants
def safety_factor(quadrants)
  quadrants.reduce(:*)
end

# Main function to solve the problem
def solve(input)
  # Parse the input
  robots = parse_input(input)

  # Simulate motion for 100 seconds
  simulate_motion(robots, SIMULATION_SECONDS)

  # Calculate quadrants
  quadrants = calculate_quadrants(robots)

  # Calculate safety factor
  safety_factor(quadrants)
end

input = File.read('2024/day_fourteen/input.txt')
result = solve(input)

# Output the result
puts "Safety Factor: #{result}"
