# Task one: Calculate the sum of valid multiplications
def sum_valid_multiplications(file_path)
  # Read the entire content of the file into a string
  memory = File.read(file_path)

  # Use regex to find all valid `mul(X, Y)` instructions
  # Capture groups (\d{1,3}) extract numbers X and Y, allowing 1 to 3 digits
  memory.scan(/mul\((\d{1,3}),(\d{1,3})\)/).sum do |x, y|
    # Convert the captured numbers to integers, multiply them, and sum the results
    x.to_i * y.to_i
  end
end

# Task two: Calculate the sum of enabled multiplications considering `do()` and `don't()` instructions
def sum_enabled_multiplications(file_path)
  # Read the entire content of the file into a string
  memory = File.read(file_path)

  # Initialize the `enabled` flag as true (multiplications are enabled by default)
  enabled = true

  # Use regex to find all `mul(X, Y)` instructions as well as `do()` and `don't()`
  memory.scan(/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/).sum do |match|
    # Check the type of match
    if match[0] && match[1] # If it's a `mul(X, Y)` instruction
      enabled ? match[0].to_i * match[1].to_i : 0 # Multiply only if enabled
    elsif match.include?("do()") # If it's a `do()` instruction
      enabled = true # Enable multiplications
      0 # `do()` does not contribute to the sum
    elsif match.include?("don't()") # If it's a `don't()` instruction
      enabled = false # Disable multiplications
      0 # `don't()` does not contribute to the sum
    else
      0 # Any other match does not affect the sum
    end
  end
end

# File path for the input
file_path = "day_three/input.txt"

# Task One: Calculate and print the total sum of valid multiplications
puts "Total sum of valid multiplications: #{sum_valid_multiplications(file_path)}"

# Task Two: Calculate and print the total sum of enabled multiplications
puts "Total sum of enabled multiplications: #{sum_enabled_multiplications(file_path)}"
