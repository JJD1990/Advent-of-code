require 'set'

class AntennaGrid
  def initialize(grid)
    @grid = grid.map(&:chars)
    @height = @grid.length
    @width = @grid[0].length
    @antennas = find_antennas
  end

  def count_antinodes
    antinodes = Set.new

    # Iterate through all frequencies
    @antennas.each do |freq, freq_antennas|
      # Compare every pair of antennas with the same frequency
      freq_antennas.combination(2).each do |antenna1, antenna2|
        dx = antenna2[0] - antenna1[0]
        dy = antenna2[1] - antenna1[1]

        # Ensure the antennas are in a straight line
        next unless straight_line?(dx, dy)

        # Check for antinodes on both sides
        [1, -1].each do |direction|
          first_antinode = [
            antenna1[0] + direction * dx * 2,
            antenna1[1] + direction * dy * 2
          ]
          second_antinode = [
            antenna2[0] + direction * dx * 2,
            antenna2[1] + direction * dy * 2
          ]

          # Add valid antinodes
          add_antinode(antinodes, first_antinode)
          add_antinode(antinodes, second_antinode)
        end
      end
    end

    antinodes.size
  end

  private

  def straight_line?(dx, dy)
    dx == 0 || dy == 0 || dx.abs == dy.abs
  end

  def add_antinode(antinodes, antinode)
    x, y = antinode
    return unless within_bounds?(x, y)
    return if @grid[y][x] != '.'

    antinodes << antinode
  end

  def find_antennas
    antennas = Hash.new { |h, k| h[k] = [] }
    
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        antennas[cell] << [x, y] unless cell == '.'
      end
    end

    antennas
  end

  def within_bounds?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end
end

# File path handling
file_path = "day_eight/input.txt"

# Read input from file
input = File.readlines(file_path, chomp: true)

grid = AntennaGrid.new(input)
puts "Unique Antinodes: #{grid.count_antinodes}"
