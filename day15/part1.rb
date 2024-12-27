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
      return Result.new(intcode, pos + 2, base, false, values) if values.length == 1

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

def draw(grid, current_location, min_x, min_y, max_x, max_y)
  system 'clear'
  max_y.downto(min_y).each do |y|
    (min_x..max_x).each do |x|
      if x == current_location[0] && y == current_location[1]
        print "$"
      elsif x == 0 && y == 0
        print 'X'
      else
        case grid[[x, y]]
        when -1
          print ' '
        when 1
          print "."
        when 0
          print "#"
        when 2
          print "O"
        end
      end
    end
    print "\n"
  end
  #print grid
end

def move
  loop do
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end

    case str
    when 'w'
      return 1
    when 'a'
      return 3
    when 's'
      return 2
    when 'd'
      return 4
    when 'q'
      abort
    end

  end
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).strip

intcode = Hash.new(0)

input.split(',').each_with_index do |code, i|
  intcode[i] = code.to_i
end

pos = 0
base = 0
grid = Hash.new(-1)
grid[[0, 0]] = 1
cmd = 0
current_location = [0, 0]
min_x = -1
max_x = 1
min_y = -1
max_y = 1

loop do

  draw(grid, current_location, min_x, min_y, max_x, max_y)
  dir = move

  new_location = nil
  case dir
    when 1
      new_location = [current_location[0], current_location[1]+1]
    when 2
      new_location = [current_location[0], current_location[1]-1]
    when 3
      new_location = [current_location[0]-1, current_location[1]]
    when 4
      new_location = [current_location[0]+1, current_location[1]]
  end

  min_x = new_location[0] if new_location[0] < min_x
  max_x = new_location[0] if new_location[0] > max_x

  min_y = new_location[1] if new_location[1] < min_y
  max_y = new_location[1] if new_location[1] > max_y

  result = compute(intcode, dir, pos, base)

  if result.halt
    puts "Game over."
    break
  end

  pos = result.pos
  base = result.base
  intcode = result.intcode

  x = result.values[0]

  grid[[new_location[0], new_location[1]]] = x
  current_location = new_location if [1, 2].include?(x)
end


