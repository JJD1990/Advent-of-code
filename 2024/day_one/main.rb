# Calculate the total distance based on the input file
# The distance is calculated by matching corresponding values from two lists (left and right)
# and summing the absolute differences between them.
def calculate_total_distance(file_path)
  # Read the input file, split lines into two lists, and transpose them
  left_list, right_list = File.readlines(file_path).map { |line| line.split.map(&:to_i) }.transpose

  # Sort both lists, pair them, and sum the absolute differences
  left_list.sort.zip(right_list.sort).sum { |a, b| (a - b).abs }
end

# Calculate the similarity score based on the input file
# The score is calculated by finding matches between numbers in the left list and their occurrences in the right list.
def calculate_similarity_score(file_path)
  # Read the input file, split lines into two lists, and transpose them
  left_list, right_list = File.readlines(file_path).map { |line| line.split.map(&:to_i) }.transpose

  # Create a hash to count occurrences of each number in the right list
  right_count = Hash.new(0)
  right_list.each { |num| right_count[num] += 1 }

  # Sum up the scores for each number in the left list
  # The score is the product of the number and its count in the right list
  left_list.sum { |num| num * right_count[num] }
end

# Specify the input file path
file_path = "day_one/input.txt"

# Part 1: Calculate and display the total distance
total_distance = calculate_total_distance(file_path)
puts "Total Distance: #{total_distance}"

# Part 2: Calculate and display the similarity score
similarity_score = calculate_similarity_score(file_path)
puts "Similarity Score: #{similarity_score}"
