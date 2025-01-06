#!/usr/bin/env ruby

def mix(secret, value)
  secret ^ value
end

def prune(secret)
  secret % 16777216
end

def generate_next_secret(secret)
  # Step 1: Multiply by 64
  result = mix(secret, secret * 64)
  result = prune(result)
  
  # Step 2: Divide by 32
  result = mix(result, result / 32)
  result = prune(result)
  
  # Step 3: Multiply by 2048
  result = mix(result, result * 2048)
  result = prune(result)
  
  result
end

def generate_nth_secret(initial_secret, n)
  current_secret = initial_secret
  n.times do
    current_secret = generate_next_secret(current_secret)
  end
  current_secret
end

input = File.read('2024/day_twenty_two/input.txt').strip.split("\n").map(&:to_i)

# Generate 2000th secret for each initial secret and sum them
sum = input.sum do |initial_secret|
  generate_nth_secret(initial_secret, 2000)
end

puts "Sum of 2000th secret numbers: #{sum}"
