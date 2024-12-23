#!/usr/bin/env ruby

class TowelMatcher
  def initialize(patterns)
    @patterns = patterns.map(&:strip)
    # Sort patterns by length for optimization
    @patterns.sort_by!(&:length).reverse!
  end

  # Check if a design can be created using available patterns
  def can_make_design?(design, memo = {})
    return true if design.empty?  # Base case: empty string is always possible
    return memo[design] if memo.key?(design)  # Use memoized result if available
    
    # Try each pattern as a potential prefix
    result = @patterns.any? do |pattern|
      if design.start_with?(pattern)
        # Recursively check if remaining design can be made
        remaining = design[pattern.length..]
        can_make_design?(remaining, memo)
      end
    end
    
    memo[design] = result  # Memoize the result
    result
  end
end

def parse_input(input)
  # Split input into patterns and designs
  patterns_section, designs_section = input.split("\n\n")
  
  # Parse patterns (strip whitespace and commas)
  patterns = patterns_section.split(',').map(&:strip)
  
  # Parse designs (one per line)
  designs = designs_section.strip.split("\n").map(&:strip)
  
  [patterns, designs]
end

def solve(input)
  patterns, designs = parse_input(input)
  matcher = TowelMatcher.new(patterns)
  
  # Count how many designs are possible
  possible_count = designs.count do |design|
    matcher.can_make_design?(design)
  end
  
  possible_count
end

# Main execution
if __FILE__ == $0
  input = File.read(File.join(__dir__, "input.txt"))
  result = solve(input)
  puts result
end

# Optional: Include test cases if needed
def run_tests
  test_input = <<~INPUT
    r, wr, b, g, bwu, rb, gb, br

    brwrr
    bggr
    gbbr
    rrbgbr
    ubwu
    bwurrg
    brgr
    bbrgwb
  INPUT
  
  result = solve(test_input)
  puts "Test result: #{result}"
  puts "Test #{result == 6 ? 'PASSED' : 'FAILED'}"
end

# Uncomment to run tests
# run_tests
