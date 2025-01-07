#!/usr/bin/env ruby

class Circuit
  def initialize
    @wires = {}
    @gates = []
  end

  def set_wire(name, value)
    @wires[name] = value
  end

  def add_gate(gate_type, input1, input2, output)
    @gates << {
      type: gate_type,
      input1: input1,
      input2: input2,
      output: output
    }
  end

  def evaluate_gate(gate)
    return false unless @wires.key?(gate[:input1]) && @wires.key?(gate[:input2])
    
    in1 = @wires[gate[:input1]]
    in2 = @wires[gate[:input2]]
    
    result = case gate[:type]
    when 'AND'
      in1 & in2
    when 'OR'
      in1 | in2
    when 'XOR'
      in1 ^ in2
    else
      raise "Unknown gate type: #{gate[:type]}"
    end
    
    if !@wires.key?(gate[:output]) || @wires[gate[:output]] != result
      @wires[gate[:output]] = result
      return true
    end
    
    false
  end

  def simulate
    changed = true
    while changed
      changed = false
      @gates.each do |gate|
        changed |= evaluate_gate(gate)
      end
    end
  end

  def get_output
    # Get all z wires sorted numerically
    z_wires = @wires.keys
                    .select { |wire| wire.start_with?('z') }
                    .sort_by { |wire| 
                      # Extract the number after 'z' and pad with zeros for proper sorting
                      wire[1..].rjust(5, '0')
                    }
    
    # Debug print z-wires in order
    z_wires.each do |wire|
      puts "#{wire}: #{@wires[wire]}"
    end

    # Build binary string from least significant to most significant bit
    binary = z_wires.reverse.map { |wire| @wires[wire] }.join
    binary.to_i(2)
  end

  def parse_input(input)
    initial_values = true
    
    input.each_line do |line|
      line.strip!
      next if line.empty?
      
      if initial_values
        if line.include?('->')
          initial_values = false
        else
          wire, value = line.split(': ')
          set_wire(wire, value.to_i)
          next
        end
      end
      
      if line =~ /(\w+) (AND|OR|XOR) (\w+) -> (\w+)/
        add_gate($2, $1, $3, $4)
      else
        raise "Invalid gate definition: #{line}"
      end
    end
  end

  def debug_print
    puts "\nAll wire values:"
    @wires.sort.each do |wire, value|
      puts "#{wire}: #{value}"
    end
  end
end

puzzle_input = File.read('2024/day_twenty_four/input.txt')
circuit = Circuit.new
circuit.parse_input(puzzle_input)
circuit.simulate
puts "Output decimal value: #{circuit.get_output}"
