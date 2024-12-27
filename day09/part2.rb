#!/usr/bin/env ruby

Command = Struct.new(:type, :args)

def command(cmd)
  cmd_s = cmd.to_s

  Command.new((cmd_s[-2..-1] || cmd_s).to_i, cmd_s[0..-3].rjust(3, '0').scan(/\d/).reverse.map(&:to_i))
end

def loc(intcode, type, pos, offset, base)
  address = pos + offset
  case type
  when 0
    intcode[address]
  when 1
    address
  when 2
    intcode[address] + base
  end
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).strip

intcode = Hash.new(0)

input.split(',').each_with_index do |code, i|
  intcode[i] = code.to_i
end

pos = 0

cmd_input = 2
move = 2
base = 0

loop do
  arg1, arg2, arg3 = nil
  cmd = command(intcode[pos])

  arg1 = loc(intcode, cmd.args[0], pos, 1, base) if cmd.type != 99
  arg2 = loc(intcode, cmd.args[1], pos, 2, base) if [1, 2, 5, 6, 7, 8].include?(cmd.type)
  arg3 = loc(intcode, cmd.args[2], pos, 3, base) if [1, 2, 7, 8].include?(cmd.type)

  case cmd.type
  when 1
    intcode[arg3] = intcode[arg1] + intcode[arg2]
    move = 4
  when 2
    intcode[arg3] = intcode[arg1] * intcode[arg2]
    move = 4
  when 3
    intcode[arg1] = cmd_input
    move = 2
  when 4
    puts intcode[arg1]
    move = 2
  when 5
    unless intcode[arg1].zero?
      pos = intcode[arg2]
      next
    end
    move = 3
  when 6
    if intcode[arg1].zero?
      pos = intcode[arg2]
      next
    end
    move = 3
  when 7
    intcode[arg3] = intcode[arg1] < intcode[arg2] ? 1 : 0
    move = 4
  when 8
    intcode[arg3] = intcode[arg1] == intcode[arg2] ? 1 : 0
    move = 4
  when 9
    base += intcode[arg1]
    move = 2
  when 99
    abort
  else
    puts "Unknown intcode #{cmd.type}"
    abort
  end

  pos += move
end
