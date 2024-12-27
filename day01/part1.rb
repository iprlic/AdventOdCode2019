#!/usr/bin/env ruby

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

puts input.split("\n").map { |m| (m.to_i / 3) - 2 }.inject(:+)
