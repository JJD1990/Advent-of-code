#!/usr/bin/env ruby
# frozen_string_literal: true

# Chronospatial Computer Simulator
class ChronospatialComputer
  attr_reader :registers, :output

  def initialize(register_a, register_b, register_c, program)
    @registers = { 'A' => register_a, 'B' => register_b, 'C' => register_c }
    @program = program
    @instruction_pointer = 0
    @output = []
  end

  # Execute the program until it halts
  def run
    while @instruction_pointer < @program.size
      opcode = @program[@instruction_pointer]
      operand = @program[@instruction_pointer + 1]
      execute_instruction(opcode, operand)
    end
    @output.join(',')
  end

  private

  # Map combo operands to their values
  def combo_value(operand)
    case operand
    when 0..3 then operand
    when 4 then @registers['A']
    when 5 then @registers['B']
    when 6 then @registers['C']
    else raise "Invalid combo operand: #{operand}"
    end
  end

  # Safe power calculation with integer result
  def safe_power(base, exponent)
    raise "Exponent too large: #{exponent}" if exponent > 31 # Prevent extremely large calculations
    2**exponent
  end

  # Execute a single instruction
  def execute_instruction(opcode, operand)
    case opcode
    when 0 # adv: Divide A by 2^(combo operand)
      denominator = safe_power(2, combo_value(operand))
      @registers['A'] = (@registers['A'] / denominator).to_i

    when 1 # bxl: B XOR literal operand
      @registers['B'] ^= operand

    when 2 # bst: B = combo operand % 8
      @registers['B'] = combo_value(operand) % 8

    when 3 # jnz: Jump if A != 0
      if @registers['A'] != 0
        @instruction_pointer = operand
        return
      end

    when 4 # bxc: B XOR C
      @registers['B'] ^= @registers['C']

    when 5 # out: Output combo operand % 8
      @output << (combo_value(operand) % 8)

    when 6 # bdv: B = A / 2^(combo operand)
      denominator = safe_power(2, combo_value(operand))
      @registers['B'] = (@registers['A'] / denominator).to_i

    when 7 # cdv: C = A / 2^(combo operand)
      denominator = safe_power(2, combo_value(operand))
      @registers['C'] = (@registers['A'] / denominator).to_i

    else
      raise "Invalid opcode: #{opcode}"
    end

    # Move to the next instruction
    @instruction_pointer += 2
  end
end

# Parse input
input = File.read('2024/day_seventeen/input.txt')
debug_info, program = input.split("\n\n")

# Parse registers
register_values = debug_info.scan(/Register ([ABC]): (\d+)/).to_h { |k, v| [k, v.to_i] }

# Parse program
program = program.strip.split(',').map(&:to_i)

# Initialize the computer
computer = ChronospatialComputer.new(
  register_values['A'],
  register_values['B'],
  register_values['C'],
  program
)

# Run the program and get the output
result = computer.run
puts "Program Output: #{result}"
