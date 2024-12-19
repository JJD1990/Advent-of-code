class DiskFragmenter
  def initialize(disk_map)
    @disk_map = disk_map
    @blocks = parse_disk_map
  end

  def compact_and_checksum
    compact_disk
    calculate_checksum
  end

  private

  def parse_disk_map
    blocks = []
    current_file_id = 0
    is_file = true  # First number is always a file length
    position = 0

    @disk_map.each_char do |char|
      length = char.to_i
      
      if is_file
        # Add file blocks with their ID
        length.times do
          blocks << current_file_id
        end
        current_file_id += 1
      else
        # Add free space blocks
        length.times do
          blocks << '.'
        end
      end
      
      is_file = !is_file
    end

    blocks
  end

  def compact_disk
    while has_gaps?
      # Find rightmost file block
      rightmost_idx = @blocks.rindex { |block| block.is_a?(Integer) }
      next unless rightmost_idx

      # Find leftmost free space
      leftmost_free_idx = @blocks.index('.')
      next unless leftmost_free_idx
      break if leftmost_free_idx > rightmost_idx

      # Move the block
      @blocks[leftmost_free_idx] = @blocks[rightmost_idx]
      @blocks[rightmost_idx] = '.'
    end
  end

  def has_gaps?
    file_positions = @blocks.each_with_index.select { |block, _| block.is_a?(Integer) }
    return false if file_positions.empty?
    
    # Check if there are any gaps between files
    file_positions.each_cons(2) do |(_, pos1), (_, pos2)|
      return true if pos2 - pos1 > 1
    end
    
    false
  end

  def calculate_checksum
    @blocks.each_with_index.sum do |block, position|
      block.is_a?(Integer) ? position * block : 0
    end
  end

  def to_s
    @blocks.join
  end
end

file_path = "2024/day_nine/input.txt"

disk_map = File.read(file_path).strip

# Create fragmenter and process
fragmenter = DiskFragmenter.new(disk_map)
checksum = fragmenter.compact_and_checksum

puts "Final checksum: #{checksum}"