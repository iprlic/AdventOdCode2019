#!/usr/bin/env ruby

def count_orbits(body, orbits)
  orbits.inject(0) { |sum, o| sum + (o[1] == body ? (1 + count_orbits(o[0], orbits)) : 0) }
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

all_orbits = input.split("\n").map { |o| o.split(')') }

puts all_orbits.inject(0) { |sum, o| sum + count_orbits(o[1], all_orbits) }
