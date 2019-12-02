#!/usr/bin/env ruby

def calculate(intcode, noun, verb)
  intcode[1] = noun
  intcode[2] = verb

  pos = 0

  loop do
    if intcode[pos] == 1
      intcode[intcode[pos + 3]] = intcode[intcode[pos + 1]] + intcode[intcode[pos + 2]]
    elsif intcode[pos] == 2
      intcode[intcode[pos + 3]] = intcode[intcode[pos + 1]] * intcode[intcode[pos + 2]]
    else
      return intcode[0]
    end

    pos += 4
  end
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

intcode = input.split(',').map(&:to_i)

99.downto(0) do |noun|
  99.downto(0).each do |verb|
    if calculate(intcode.dup, noun, verb) == 19_690_720
      puts 100 * noun + verb
      exit
    end
  end
end
