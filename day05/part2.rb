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

cmd_input = 5
move = 2

loop do
  arg1, arg2, arg3 = nil
  cmd = command(intcode[pos])

  arg1 = cmd.args[0].zero? ? intcode[intcode[pos + 1]] : intcode[pos + 1] if cmd.type != 99
  arg2 = cmd.args[1].zero? ? intcode[intcode[pos + 2]] : intcode[pos + 2] if [1, 2, 5, 6, 7, 8].include?(cmd.type)
  arg3 = intcode[pos + 3] if [7, 8].include?(cmd.type)

  case cmd.type
  when 1
    intcode[intcode[pos + 3]] = arg1 + arg2
    move = 4
  when 2
    intcode[intcode[pos + 3]] = arg1 * arg2
    move = 4
  when 3
    intcode[intcode[pos + 1]] = cmd_input
    move = 2
  when 4
    puts arg1
    move = 2
  when 5
    unless arg1.zero?
      pos = arg2
      next
    end
    move = 3
  when 6
    if arg1.zero?
      pos = arg2
      next
    end
    move = 3
  when 7
    intcode[arg3] = arg1 < arg2 ? 1 : 0
    move = 4
  when 8
    intcode[arg3] = arg1 == arg2 ? 1 : 0
    move = 4
  when 99
    abort
  else
    puts "Unknown intcode #{cmd.type}"
    abort
  end

  pos += move
end
