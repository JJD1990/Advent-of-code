# Define a method to check if a report's levels are safe
# A report is safe if:
# 1. The levels are either all increasing or all decreasing.
# 2. Any two adjacent levels differ by at least 1 and at most 3.
def safe?(levels)
  # Check if all adjacent levels are increasing by 1-3
  increasing = levels.each_cons(2).all? { |a, b| (1..3).cover?(b - a) }
  # Check if all adjacent levels are decreasing by 1-3
  decreasing = levels.each_cons(2).all? { |a, b| (1..3).cover?(a - b) }
  # Return true if either condition is met
  increasing || decreasing
end

# Task 1: Count the number of safe reports
def task_one_safe_reports(file_path)
  # Read each line from the file and convert it to an array of integers
  reports = File.readlines(file_path).map { |line| line.split.map(&:to_i) }
  # Count how many reports are safe using the `safe?` method
  reports.count { |report| safe?(report) }
end

# Task 2: Count the number of safe reports with the Problem Dampener
def task_two_safe_reports(file_path)
  # Read each line from the file and convert it to an array of integers
  reports = File.readlines(file_path).map { |line| line.split.map(&:to_i) }

  # Define a helper method to check if a report can be made safe by removing one level
  def safe_with_removal?(levels)
    # Iterate through each level and check if the report is safe after removing it
    levels.each_with_index.any? { |_, i| safe?(levels[0...i] + levels[i + 1..]) }
  end

  # Count reports that are safe either directly or by removing one level
  reports.count { |report| safe?(report) || safe_with_removal?(report) }
end

# File path for the input data
file_path = "day_two/input.txt"

# Task 1: Calculate and print the number of safe reports
task_one_result = task_one_safe_reports(file_path)
puts "Task 1: Number of safe reports: #{task_one_result}"

# Task 2: Calculate and print the number of safe reports with the Problem Dampener
task_two_result = task_two_safe_reports(file_path)
puts "Task 2: Number of safe reports with Problem Dampener: #{task_two_result}"
