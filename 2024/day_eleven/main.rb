# Class to simulate the transformation of Plutonian pebbles over multiple blinks
class PlutonianPebbles
  def initialize(initial_stones)
    # Convert input strings to array of integers
    @stones = initial_stones.split.map(&:to_i)
  end

  # Process stones for specified number of blinks
  def process_blinks(num_blinks)
    num_blinks.times do |blink|
      transform_stones
      # Uncomment for debugging:
      # puts "After blink #{blink + 1}: #{@stones.join(' ')}"
    end
    @stones.size
  end

  private

  # Transform all stones according to the rules
  def transform_stones
    # We'll collect new stones in this array
    new_stones = []

    @stones.each do |stone|
      # Apply first matching rule
      if stone == 0
        # Rule 1: 0 becomes 1
        new_stones << 1
      elsif has_even_digits?(stone)
        # Rule 2: Split stones with even number of digits
        left, right = split_stone(stone)
        new_stones << left << right
      else
        # Rule 3: Multiply by 2024
        new_stones << (stone * 2024)
      end
    end

    @stones = new_stones
  end

  # Check if a number has an even number of digits
  def has_even_digits?(number)
    number.to_s.length.even?
  end

  # Split a number into two parts
  def split_stone(number)
    digits = number.to_s
    mid = digits.length / 2
    
    # Convert back to integers, handling leading zeros properly
    left = digits[0...mid].to_i
    right = digits[mid..-1].to_i
    
    [left, right]
  end
end

file_path = "2024/day_eleven/input.txt"
initial_stones = File.read(file_path).strip

# Create simulator and process blinks
simulator = PlutonianPebbles.new(initial_stones)
final_count = simulator.process_blinks(25)

puts "Number of stones after 25 blinks: #{final_count}"