DIRECTIONS = [1 + 0i, -1 + 0i, 0 + 1i, 0 - 1i].freeze

def parse_map(input)
  lines = input.split("\n")
  map = lines.flat_map.with_index do |row, ri|
    row.chars.map.with_index do |cell, ci|
      [ri + ci * 1i, cell]
    end
  end.to_h
  
  {
    walls: map.select { |_, v| v == '#' }.keys.to_set,
    start: map.find { |_, v| v == 'S' }.first,
    target: map.find { |_, v| v == 'E' }.first,
    size: map.keys.map(&:real).max
  }
end

def find_path(walls, size, start, target)
  visited = Set[start]
  parents = { start => nil }
  queue = [start]

  until queue.empty?
    current = queue.shift
    neighbors = DIRECTIONS
      .map { |dir| current + dir }
      .select { |pos| pos.rect.all? { |c| (0..size).include?(c) } }
      .reject { |pos| walls.include?(pos) || visited.include?(pos) }

    neighbors.each do |neighbor|
      queue << neighbor
      visited << neighbor
      parents[neighbor] = current
    end
  end

  # Reconstruct path from target to start
  path = [target]
  current = target
  until current == start
    current = parents[current]
    path << current
  end
  
  # Return path with distances
  path.reverse.map.with_index
end

def count_cheats(path, max_dist)
  path.sum do |pos_a, dist_a|
    path.count do |pos_b, dist_b|
      manhattan_dist = (pos_a.real - pos_b.real).abs + (pos_a.imag - pos_b.imag).abs
      manhattan_dist <= max_dist && dist_b + manhattan_dist <= dist_a - 100
    end
  end
end

input = File.read(File.join(__dir__, 'input.txt'))
map_data = parse_map(input)

# Find shortest path
path = find_path(map_data[:walls], map_data[:size], map_data[:start], map_data[:target])

part_1 = count_cheats(path, 2)
part_2 = count_cheats(path, 20)

puts "count_cheats part 1: #{part_1}"
puts "count_cheats part 2: #{part_2}"