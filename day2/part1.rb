#!/usr/bin/env ruby

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

intcode = input.split(',').map(&:to_i)

# restore state
intcode[1] = 12
intcode[2] = 2

pos = 0

loop do
  if intcode[pos] == 1
    intcode[intcode[pos + 3]] = intcode[intcode[pos + 1]] + intcode[intcode[pos + 2]]
  elsif intcode[pos] == 2   
    intcode[intcode[pos + 3]] = intcode[intcode[pos + 1]] * intcode[intcode[pos + 2]]
  else
    puts intcode[0]
    break
  end

  pos += 4
end
