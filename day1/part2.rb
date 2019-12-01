#!/usr/bin/env ruby

def get_fuel(mass)
  res = (mass.to_i / 3) - 2
  res > 0 ? res + get_fuel(res) : 0
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

puts input.split("\n").map { |m| get_fuel(m.to_i) }.inject(:+)
