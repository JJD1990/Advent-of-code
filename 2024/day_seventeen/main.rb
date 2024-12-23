#!/usr/bin/env ruby

class Computer
  attr_accessor :registers, :instruction_pointer, :output
  
  def initialize(program_str)
    @registers = { 'A' => 0, 'B' => 0, 'C' => 0 }
    @instruction_pointer = 0
    @program = program_str.strip.split(',').map(&:to_i)
    @output = []
  end

  # Get value based on combo operand rules
  def get_combo_value(operand)
    case operand
    when 0..3 then operand  # Literal values 0-3
    when 4 then @registers['A']
    when 5 then @registers['B']
    when 6 then @registers['C']
    else raise "Invalid combo operand: #{operand}"
    end
  end

  # Execute a single instruction
  def execute_instruction(opcode, operand)
    case opcode
    when 0  # adv - divide A by 2^combo_operand, store in A
      power = get_combo_value(operand)
      @registers['A'] = (@registers['A'] / (2 ** power)).to_i
      @instruction_pointer += 2
    
    when 1  # bxl - XOR B with literal operand
      @registers['B'] ^= operand
      @instruction_pointer += 2
    
    when 2  # bst - store combo_operand mod 8 in B
      @registers['B'] = get_combo_value(operand) % 8
      @instruction_pointer += 2
    
    when 3  # jnz - jump if A != 0
      if @registers['A'] != 0
        @instruction_pointer = operand
      else
        @instruction_pointer += 2
      end
    
    when 4  # bxc - XOR B with C
      @registers['B'] ^= @registers['C']
      @instruction_pointer += 2
    
    when 5  # out - output combo_operand mod 8
      @output << (get_combo_value(operand) % 8)
      @instruction_pointer += 2
    
    when 6  # bdv - divide A by 2^combo_operand, store in B
      power = get_combo_value(operand)
      @registers['B'] = (@registers['A'] / (2 ** power)).to_i
      @instruction_pointer += 2
    
    when 7  # cdv - divide A by 2^combo_operand, store in C
      power = get_combo_value(operand)
      @registers['C'] = (@registers['A'] / (2 ** power)).to_i
      @instruction_pointer += 2
    end
  end

  # Run the program until it halts
  def run
    while @instruction_pointer < @program.length
      opcode = @program[@instruction_pointer]
      operand = @program[@instruction_pointer + 1]
      execute_instruction(opcode, operand)
    end
    @output.join(',')
  end
end

# Parse input and set up initial state
def parse_input(input)
  lines = input.split("\n")
  registers = {}
  program = ""
  
  lines.each do |line|
    if line.start_with?("Register")
      reg, value = line.scan(/Register (.): (\d+)/).first
      registers[reg] = value.to_i
    elsif line.start_with?("Program:")
      program = line.split(": ").last
    end
  end
  
  [registers, program]
end

input = File.read(File.join(__dir__, "input.txt"))
registers, program = parse_input(input)

computer = Computer.new(program)
computer.registers = registers
puts computer.run