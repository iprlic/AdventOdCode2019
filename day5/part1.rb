#!/usr/bin/env ruby

Command = Struct.new(:type, :args)

def command(cmd)
  cmd_s = cmd.to_s

  Command.new((cmd_s[-2..-1] || cmd_s).to_i, cmd_s[0..-3].rjust(3, '0').scan(/\d/).reverse.map(&:to_i))
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

intcode = input.split(',').map(&:to_i)

pos = 0

cmd_input = 1
move = 2

loop do
  cmd = command(intcode[pos])

  puts "#{cmd.type}: #{cmd.args}, #{intcode[pos]}, #{pos}"
  case cmd.type
  when 1
    arg1 = cmd.args[0].zero? ? intcode[intcode[pos + 1]] : intcode[pos + 1]
    arg2 = cmd.args[1].zero? ? intcode[intcode[pos + 2]] : intcode[pos + 2]

    intcode[intcode[pos + 3]] = arg1 + arg2
    move = 4
  when 2
    arg1 = cmd.args[0].zero? ? intcode[intcode[pos + 1]] : intcode[pos + 1]
    arg2 = cmd.args[1].zero? ? intcode[intcode[pos + 2]] : intcode[pos + 2]

    intcode[intcode[pos + 3]] = arg1 * arg2
    move = 4
  when 3
    intcode[intcode[pos + 1]] = cmd_input
    move = 2
  when 4
    arg1 = cmd.args[0].zero? ? intcode[intcode[pos + 1]] : intcode[pos + 1]
    puts arg1
    move = 2
  else
    puts "Unknown intcode #{cmd.type}"
    break
  end

  pos += move
end
