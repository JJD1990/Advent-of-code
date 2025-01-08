# Class to analyze lock and key schematics and find valid combinations
class LockKeyAnalyzer
  def initialize(input)
    @input = input
    @locks = []
    @keys = []
  end

  # Main method to process input and count valid lock/key pairs
  def count_valid_pairs
    parse_schematics
    puts "Found #{@locks.length} locks and #{@keys.length} keys"
    puts "\nLocks:"
    @locks.each_with_index { |lock, i| puts "Lock #{i}: #{lock.inspect}" }
    puts "\nKeys:"
    @keys.each_with_index { |key, i| puts "Key #{i}: #{key.inspect}" }
    find_valid_pairs
  end

  private

  # Converts a schematic string into an array of heights
  # For locks: measures from top down
  # For keys: measures from bottom up
  def convert_to_heights(schematic, is_lock)
    rows = schematic.split("\n")
    heights = Array.new(rows[0].length, 0)
    
    if is_lock
      # For locks, find first '#' from top
      rows[0].length.times do |col|
        row_idx = rows.find_index { |row| row[col] == '#' }
        heights[col] = row_idx ? rows.length - row_idx - 1 : 0
      end
    else
      # For keys, find last '#' from bottom
      rows[0].length.times do |col|
        row_idx = rows.rindex { |row| row[col] == '#' }
        heights[col] = row_idx ? row_idx : 0
      end
    end
    
    heights
  end

  # Parses input string into separate lock and key schematics
  def parse_schematics
    current_schematic = []
    is_parsing_lock = true  # First schematics are locks

    @input.each_line do |line|
      line.chomp!
      
      if line.empty? && !current_schematic.empty?
        # Process completed schematic
        heights = convert_to_heights(current_schematic.join("\n"), is_parsing_lock)
        puts "\nProcessing schematic (#{is_parsing_lock ? 'lock' : 'key'}):"
        puts current_schematic
        puts "Heights: #{heights.inspect}"
        
        if is_parsing_lock && line.include?('#####')
          @locks << heights
          puts "Added as lock"
        elsif !is_parsing_lock && line.include?('.....')
          @keys << heights
          puts "Added as key"
        else
          is_parsing_lock = false  # Switch to parsing keys when pattern changes
          puts "Switching to parsing keys"
        end
        
        current_schematic = []
      elsif !line.empty?
        current_schematic << line
      end
    end

    # Process last schematic if needed
    if !current_schematic.empty?
      heights = convert_to_heights(current_schematic.join("\n"), is_parsing_lock)
      if is_parsing_lock
        @locks << heights
      else
        @keys << heights
      end
    end
  end

  # Checks if a lock and key pair is valid (no overlaps)
  def is_valid_pair?(lock, key)
    return false if lock.length != key.length
    
    lock.length.times do |i|
      if (lock[i] + key[i]) > 7
        puts "Invalid pair - overlap at position #{i}: lock #{lock[i]} + key #{key[i]} = #{lock[i] + key[i]}"
        return false
      end
    end
    puts "Valid pair found: lock #{lock.inspect} with key #{key.inspect}"
    true
  end

  # Counts number of valid lock/key pairs
  def find_valid_pairs
    valid_pairs = 0
    
    @locks.each_with_index do |lock, lock_idx|
      @keys.each_with_index do |key, key_idx|
        if is_valid_pair?(lock, key)
          valid_pairs += 1
          puts "Lock #{lock_idx} and Key #{key_idx} form a valid pair"
        end
      end
    end
    
    valid_pairs
  end
end

# Read input file from the specified path
input_path = File.join('2024', 'day_twenty_five', 'input.txt')
begin
  input_data = File.read(input_path)
  puts "Input file read successfully, length: #{input_data.length} characters"
rescue => e
  puts "Error reading input file: #{e.message}"
  exit 1
end

# Create analyzer and process input
analyzer = LockKeyAnalyzer.new(input_data)
result = analyzer.count_valid_pairs

# Output result
puts "\nFinal result - Number of valid lock/key pairs: #{result}"