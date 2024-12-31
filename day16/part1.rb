#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).chars.map(&:to_i)

def fft(input)
  base_pattern = [0, 1, 0, -1]
  output = []

  input.each_with_index do |_, i|
    pattern = base_pattern.flat_map { |n| [n] * (i + 1) }

    sum = input.each_with_index.inject(0) do |acc, (n, j)|
      acc + n * pattern[(j + 1) % pattern.size]
    end

    output << sum.abs % 10
  end

  output
end

100.times do
  input = fft(input)
end

puts input.take(8).join
