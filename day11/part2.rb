#!/usr/bin/env ruby

Command = Struct.new(:type, :args)
Result = Struct.new(:intcode, :pos, :base, :halt, :values)

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

def compute(intcode, cmd_input, pos, base)
  move = 2
  values = []

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
      values << intcode[arg1]
      return Result.new(intcode, pos + 2, base, false, values) if values.length == 2

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
      return Result.new(intcode, pos, base, true, nil)
    else
      puts "Unknown intcode #{cmd.type}"
      abort
    end

    pos += move
  end
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).strip

intcode = Hash.new(0)

input.split(',').each_with_index do |code, i|
  intcode[i] = code.to_i
end

white_panels = [[0, 0]]
current_panel = [0, 0]
pos = 0
base = 0
cmd = 0
facing = 0

loop do
  x = current_panel[0]
  y = current_panel[1]

  panel_key = [x, y]

  cmd = white_panels.include?(panel_key) ? 1 : 0

  result = compute(intcode, cmd, pos, base)

  break if result.halt

  pos = result.pos
  base = result.base
  intcode = result.intcode

  if result.values[0].zero?
    white_panels.delete(panel_key) if white_panels.include?(panel_key)
  else
    white_panels << panel_key unless white_panels.include?(panel_key)
  end

  rotate = result.values[1]

  facing += rotate.zero? ? -1 : 1
  facing = 3 if facing == -1
  facing = 0 if facing == 4

  case facing
  when 0
    current_panel = [x, y + 1]
  when 1
    current_panel = [x + 1, y]
  when 2
    current_panel = [x, y - 1]
  when 3
    current_panel = [x - 1, y]
  end
end

white_panels.sort! { |a, b| a[0] <=> b[0] }

min_x = white_panels.first[0]
max_x = white_panels.last[0]

white_panels.sort! { |a, b| a[1] <=> b[1] }

min_y = white_panels.first[1]
max_y = white_panels.last[1]

(min_x..max_x).to_a.each do |x|
  (min_y..max_y).to_a.each do |y|
    print white_panels.include?([x, y]) ? '#' : '.'
  end
  print "\n"
end
