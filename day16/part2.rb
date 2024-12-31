#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).chars.map(&:to_i)
offset = input.take(7).join.to_i
input = input * 10_000

if offset < input.size / 2
  raise 'This solution only works if the offset is in the second half of the input'
end


input = input.drop(offset)
reversed = input.reverse

def ftt(reversed)
  prev_sum = 0
  reversed.each_with_index.map do |n, i|
    prev_sum += n
    prev_sum % 10
  end
end


100.times do
  reversed = ftt(reversed)
end

puts reversed.reverse.take(8).join
