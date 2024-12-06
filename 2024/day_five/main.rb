require 'set'

# Parse the rules and updates from the input file
# This function splits the file into page ordering rules and update sequences.
def parse_rules_and_updates(file_path)
  lines = File.readlines(file_path, chomp: true) # Read all lines from the file
  # Separate rules (lines containing '|') from updates (remaining lines)
  rules, updates = lines.partition { |line| line.include?("|") }

  # Parse rules into pairs of integers (X, Y from X|Y)
  parsed_rules = rules.map do |rule|
    before, after = rule.split("|").map(&:to_i)
    [before, after]
  end

  # Parse updates into arrays of integers
  parsed_updates = updates.map { |update| update.split(",").map(&:to_i) }

  [parsed_rules, parsed_updates]
end

# Check if an update sequence is in the correct order based on the rules
def valid_update?(update, rules)
  # Ensure all applicable rules are satisfied
  rules.all? do |before, after|
    # Skip rules where one or both pages are not in the update
    next true unless update.include?(before) && update.include?(after)
    # Check if 'before' appears earlier than 'after' in the update
    update.index(before) < update.index(after)
  end
end

# Sort an update according to the rules
def sort_update(update, rules)
  # Assign a priority to each page based on the rules
  update.sort_by do |page|
    rules.inject(0) do |priority, (before, after)|
      if page == before
        priority - 1 # Pages that must come first get lower priority
      elsif page == after
        priority + 1 # Pages that must come later get higher priority
      else
        priority # No change for unrelated pages
      end
    end
  end
end

# Calculate the sum of middle page numbers
# If `correct_only` is true, process only updates in correct order;
# otherwise, correct the order of invalid updates first.
def calculate_middle_sum(file_path, correct_only: true)
  rules, updates = parse_rules_and_updates(file_path) # Parse input

  # Determine which updates to process based on the flag
  updates_to_process = if correct_only
                         # Select updates already in correct order
                         updates.select { |update| valid_update?(update, rules) }
                       else
                         # Correct the order of invalid updates
                         updates.reject { |update| valid_update?(update, rules) }
                               .map { |update| sort_update(update, rules) }
                       end

  # Calculate the sum of middle page numbers in each update
  updates_to_process.sum do |update|
    next 0 if update.empty? # Skip empty updates
    middle_index = update.size / 2 # Determine middle index
    update[middle_index] # Add the middle page number
  end
end

# Part One: Sum of middle page numbers of correctly ordered updates
file_path = "day_five/input.txt" # Input file path
part_one_result = calculate_middle_sum(file_path, correct_only: true)
puts "Part One: Total sum of middle page numbers of correctly-ordered updates: #{part_one_result}"

# Part Two: Sum of middle page numbers of corrected updates
part_two_result = calculate_middle_sum(file_path, correct_only: false)
puts "Part Two: Total sum of middle page numbers of corrected updates: #{part_two_result}"
