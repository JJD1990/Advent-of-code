# Parse input grid
grid = ARGF.readlines.flat_map.with_index do |line, y|
  line.chomp.chars.map.with_index { |cell, x| [x + 1i * y, cell] }
end.to_h

# Group antenna coordinates by frequency (excluding empty cells)
antenna_coords = grid
                   .reject { |_, cell| cell == '.' }
                   .group_by { |_, cell| cell }
                   .transform_values { |pairs| pairs.map(&:first) }

# Part 1: Find unique antinodes based on distance rule
def find_antinodes_part1(antenna_coords, grid)
  antinode_positions = []

  antenna_coords.each_value do |coords|
    coords.combination(2) do |first, second|
      vector = second - first

      # Calculate potential antinodes on either side
      antinode1 = first - vector
      antinode2 = second + vector

      # Add valid antinodes within the grid
      antinode_positions << antinode1 if grid.key?(antinode1)
      antinode_positions << antinode2 if grid.key?(antinode2)
    end
  end

  antinode_positions.uniq.count
end

def find_antinodes_part2(antenna_coords, grid)
  antinode_positions = []

  antenna_coords.each_value do |coords|
    coords.combination(2) do |first, second|
      vector = second - first

      # Iterate through the grid and find aligned positions
      grid.each_key do |coord|
        # Check if the point is aligned with the antenna pair
        vector_to_first = coord - first
        vector_to_second = coord - second

        # Calculate alignment by checking if vectors are scalar multiples
        aligned_to_first = (vector_to_first.real * vector.imag == vector_to_first.imag * vector.real)
        aligned_to_second = (vector_to_second.real * vector.imag == vector_to_second.imag * vector.real)

        # Add position if it aligns with both antennas
        if aligned_to_first || aligned_to_second
          antinode_positions << coord
        end
      end
    end
  end

  # Include all antenna positions as antinodes
  antinode_positions += antenna_coords.values.flatten

  antinode_positions.uniq.count
end


# Solve Part 1
part1_result = find_antinodes_part1(antenna_coords, grid)
puts "Part 1: #{part1_result}"

# Solve Part 2
part2_result = find_antinodes_part2(antenna_coords, grid)
puts "Part 2: #{part2_result}"
