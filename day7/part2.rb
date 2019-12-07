#!/usr/bin/env ruby

Command = Struct.new(:type, :args)
Output = Struct.new(:intcode, :result, :halt, :position)

def command(cmd)
  cmd_s = cmd.to_s

  Command.new((cmd_s[-2..-1] || cmd_s).to_i, cmd_s[0..-3].rjust(3, '0').scan(/\d/).reverse.map(&:to_i))
end

def run_intcode(intcode, inputs, pos = 0, move = 2)
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
      intcode[intcode[pos + 1]] = inputs.shift
      move = 2
    when 4
      return Output.new(intcode, arg1, false, pos + 2)
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
      return Output.new(intcode, nil, true, pos)
    else
      puts "Unknown intcode #{cmd.type}"
      abort
    end

    pos += move
  end

end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

intcode = input.split(',').map(&:to_i)

permutations = (5..9).to_a.permutation.to_a

max = 0

permutations.each do |perm|
  prev = 0

  codes = {}
  machine_cnt = 0

  perm.each do |phase|
    codes[machine_cnt] = run_intcode(intcode.dup, [phase, prev])

    prev = codes[machine_cnt].result
    machine_cnt += 1
  end

  prev_machine = 4

  last = nil
  last_result = nil

  loop do
    codes.each do |i, machine|
      codes[i] = run_intcode(machine.intcode, [codes[prev_machine].result], machine.position, 0)

      if machine.halt && i == 4
        last_result = last
        break
      end
      last = machine.result if i == 4

      prev_machine = i
    end

    break unless last_result.nil?
  end

  if last > max
    max = last
  end
end

puts max
