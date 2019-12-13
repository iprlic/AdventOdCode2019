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
      return Result.new(intcode, pos + 2, base, false, values) if values.length == 3

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

def draw(grid, score)
  system 'clear'
  keys = grid.keys

  keys.sort! { |a, b| a[0] <=> b[0] }

  min_x = keys.first[0]
  max_x = keys.last[0]

  keys.sort! { |a, b| a[1] <=> b[1] }

  min_y = keys.first[1]
  max_y = keys.last[1]

  (min_y..max_y).to_a.each do |y|
    (min_x..max_x).to_a.each do |x|
      case grid[[x, y]]
      when 0
        print " "
      when 1
        print "#"
      when 2
        print "="
      when 3
        print "-"
      when 4
        print "*"
      end
    end
    print "\n"
  end

  puts "Result: #{score}"
end

def move(ball, paddle)
  return 0 if ball.nil? || paddle.nil?

  return -1 if paddle[0] > ball[0]
  return 1 if paddle[0] < ball[0]
  return 0
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).strip

intcode = Hash.new(0)

input.split(',').each_with_index do |code, i|
  intcode[i] = code.to_i
end

pos = 0
base = 0
grid = Hash.new(0)
cmd = 0

intcode[0] = 2 # coins
score = 0
game_started = false
ball = nil
paddle = nil

loop do
  result = compute(intcode, cmd, pos, base)

  if result.halt
    puts "Game over. Result: #{score}"
    break
  end

  pos = result.pos
  base = result.base
  intcode = result.intcode

  x = result.values[0]
  y = result.values[1]
  id = result.values[2]

  if x == -1 && y == 0
    score = id
    game_started = true if !game_started
  else
    ball = [x, y] if id == 4
    paddle = [x, y] if id == 3
    grid[[x,y]] = id

    if game_started
      #draw(grid, score)
      cmd = move(ball, paddle)

      #sleep(0.03)
    end
  end
end


