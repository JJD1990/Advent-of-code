# Function to calculate the total calibration result
# Handles both Part One and Part Two, considering addition (+), multiplication (*), and concatenation (||) for Part Two.
def total_calibration_result(file_path, include_concat: false)
  # Read equations from the input file
  equations = File.readlines(file_path, chomp: true)
  
  # Store all valid results
  valid_results = []

  # Process each line in the input file
  equations.each do |line|
    # Split the line into the target value and the list of numbers
    target, *numbers = line.split(/:| /).map(&:to_i)
    
    # Check if the equation is valid with the given operators
    if include_concat
      # Part Two: Include concatenation operator (||) in the validation
      valid_results << target if valid_equation_with_concat?(target, numbers)
    else
      # Part One: Only use addition (+) and multiplication (*)
      valid_results << target if valid_equation?(target, numbers)
    end
  end

  valid_results.sum
end

# Function to validate an equation using only addition (+) and multiplication (*)
def valid_equation?(target, numbers)
  # Generate all possible combinations of addition (+) and multiplication (*)
  operators_combinations = ['+', '*'].repeated_permutation(numbers.size - 1)

  # Check if any operator combination produces the target value
  operators_combinations.any? do |operators|
    evaluate(numbers, operators) == target
  end
end

# Function to validate an equation using addition (+), multiplication (*), and concatenation (||)
def valid_equation_with_concat?(target, numbers)
  # Generate all possible combinations of addition (+), multiplication (*), and concatenation (||)
  operators_combinations = ['+', '*', '||'].repeated_permutation(numbers.size - 1)

  # Check if any operator combination produces the target value
  operators_combinations.any? do |operators|
    evaluate_with_concat(numbers, operators) == target
  end
end

# Function to evaluate an equation using a list of numbers and operators
# Handles addition (+) and multiplication (*) for Part One
def evaluate(numbers, operators)
  result = numbers[0] # Start with the first number
  operators.each_with_index do |operator, index|
    case operator
    when '+'
      result += numbers[index + 1] # Add the next number
    when '*'
      result *= numbers[index + 1] # Multiply by the next number
    end
  end
  result
end

# Function to evaluate an equation using addition (+), multiplication (*), and concatenation (||)
def evaluate_with_concat(numbers, operators)
  result = numbers[0] # Start with the first number
  operators.each_with_index do |operator, index|
    case operator
    when '+'
      result += numbers[index + 1] # Add the next number
    when '*'
      result *= numbers[index + 1] # Multiply by the next number
    when '||'
      # Concatenate the digits of the numbers
      result = (result.to_s + numbers[index + 1].to_s).to_i
    end
  end
  result
end

file_path = "day_seven/input.txt"

# Part One: Total calibration result using only addition and multiplication
part_one_result = total_calibration_result(file_path, include_concat: false)
puts "Part One: Total Calibration Result: #{part_one_result}"

# Part Two: Total calibration result using addition, multiplication, and concatenation
part_two_result = total_calibration_result(file_path, include_concat: true)
puts "Part Two: Total Calibration Result with Concatenation: #{part_two_result}"
