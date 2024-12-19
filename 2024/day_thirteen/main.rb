# frozen_string_literal: true

require 'matrix'

# Define the input pattern for parsing claw machine configurations
PATTERN = /Button A: X\+(\d+), Y\+(\d+)\s+Button B: X\+(\d+), Y\+(\d+)\s+Prize: X=(\d+), Y=(\d+)/.freeze

# Parse the input and extract equations for each machine
def parse_input(input)
  input.scan(PATTERN).map do |match|
    # Extract values for button movements and prize coordinates
    ax, ay, bx, by, px, py = match.map(&:to_i)
    button_matrix = Matrix[[ax, bx], [ay, by]]
    prize_vector = Matrix.column_vector([px, py])
    [button_matrix, prize_vector]
  end
end

# Solve the claw machine equations to find the minimum token cost
def solve_equations(equations)
  total_tokens = 0

  equations.each do |button_matrix, prize_vector|
    # Try to calculate the solution using matrix inversion
    begin
      solution = button_matrix.inverse * prize_vector
      a_presses = solution[0, 0]
      b_presses = solution[1, 0]

      # Check if the solution yields integer button presses
      if a_presses.denominator == 1 && b_presses.denominator == 1
        total_tokens += (3 * a_presses + b_presses).to_i
      end
    rescue Exception
      # Skip invalid configurations (e.g., non-invertible matrices)
      next
    end
  end

  total_tokens
end

def part1(input)
  equations = parse_input(input)
  solve_equations(equations)
end

input = File.read('2024/day_thirteen/input.txt')
result = part1(input)

puts "Part 1: #{result}"
