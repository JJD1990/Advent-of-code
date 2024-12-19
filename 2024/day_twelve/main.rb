# Class to handle garden plot regions and calculate fencing costs
class GardenGroups
  def initialize(map)
    # Convert input strings to 2D array
    @map = map.map(&:chars)
    @height = @map.length
    @width = @map[0].length
    # Track visited positions during region detection
    @visited = Array.new(@height) { Array.new(@width, false) }
  end

  # Calculate total price for all regions
  def calculate_total_price
    total_price = 0
    
    # Iterate through each position in the map
    @height.times do |y|
      @width.times do |x|
        # Skip if already visited
        next if @visited[y][x]
        
        # Find region and calculate its price
        region = find_region(y, x, @map[y][x])
        next if region.empty?
        
        area = region.size
        perimeter = calculate_perimeter(region)
        price = area * perimeter
        
        total_price += price
      end
    end
    
    total_price
  end

  private

  # Find all connected positions with the same plant type
  def find_region(start_y, start_x, plant_type)
    region = []
    queue = [[start_y, start_x]]
    
    while !queue.empty?
      y, x = queue.shift
      next if y < 0 || y >= @height || x < 0 || x >= @width  # Skip out of bounds
      next if @visited[y][x]  # Skip visited
      next if @map[y][x] != plant_type  # Skip different plant types
      
      @visited[y][x] = true
      region << [y, x]
      
      # Add adjacent positions to queue
      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dy, dx|
        queue << [y + dy, x + dx]
      end
    end
    
    region
  end

  # Calculate perimeter of a region
  def calculate_perimeter(region)
    perimeter = 0
    
    region.each do |y, x|
      # Check each side of the current position
      [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |dy, dx|
        new_y, new_x = y + dy, x + dx
        
        # Add to perimeter if:
        # - Position is out of bounds, or
        # - Position contains a different plant type
        if new_y < 0 || new_y >= @height || new_x < 0 || new_x >= @width ||
           @map[new_y][new_x] != @map[y][x]
          perimeter += 1
        end
      end
    end
    
    perimeter
  end
end

# File path handling
file_path = "2024/day_twelve/input.txt"

# Read and process input
input = File.readlines(file_path, chomp: true)

# Create garden groups object and calculate result
garden = GardenGroups.new(input)
total_price = garden.calculate_total_price

puts "Total price of fencing: #{total_price}"