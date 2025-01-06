#!/usr/bin/env ruby

# Read and parse the input file
def parse_connections(input)
  connections = Hash.new { |h, k| h[k] = Set.new }
  
  input.each_line do |line|
    comp1, comp2 = line.strip.split('-')
    connections[comp1] << comp2
    connections[comp2] << comp1
  end
  
  connections
end

# Find all sets of three interconnected computers
def find_connected_triples(connections)
  triples = Set.new
  computers = connections.keys
  
  computers.combination(3).each do |triple|
    # Check if all computers in the triple are connected to each other
    if triple.all? { |comp1| 
      triple.all? { |comp2| 
        comp1 == comp2 || connections[comp1].include?(comp2)
      }
    }
      # Sort the triple to ensure uniqueness when adding to set
      triples.add(triple.sort)
    end
  end
  
  triples
end

# Count triples containing at least one computer starting with 't'
def count_t_triples(triples)
  triples.count { |triple| triple.any? { |comp| comp.start_with?('t') } }
end

# Main program
if __FILE__ == $0
  require 'set'
  
  input = File.read('2024/day_twenty_three/input.txt')
  connections = parse_connections(input)
  triples = find_connected_triples(connections)
  t_count = count_t_triples(triples)
  
  # Output results
  puts "Total interconnected triples: #{triples.size}"
  puts "Triples with 't' computers: #{t_count}"
end
