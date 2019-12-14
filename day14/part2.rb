#!/usr/bin/env ruby

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).strip


def components(reactions, el, cnt, leftovers)
  (0..(reactions.length-1)).each do |i|

    cnt = cnt - leftovers[el]

    if cnt < 0
      leftovers[el] = -cnt
      return 0
    else
      leftovers[el] = 0
    end

    return 0 if cnt == 0

    ores = 0
    reaction = reactions[i]
    next if reaction['r'][el].nil?

    num = reaction['r'][el] - leftovers[el]

    reactions_needed = (cnt / num) + (cnt % num == 0 ? 0 : 1)
    leftovers[el] = reactions_needed * num - cnt

    #puts "#{cnt}, #{num}, #{reactions_needed}"

    inp = reaction['i']

    inp.each do |j|
      if j['ORE'].nil?
        ores += components(reactions, j.keys.first , j.values.first * reactions_needed, leftovers)[0]
      else
        ores += reactions_needed * j['ORE']
      end
    end

    return [ores, leftovers]
  end
end

reactions = input.split("\n").map do |r|
  tmp = r.split(' => ')
  res_a = tmp[1].split(' ')
  res = { res_a[1] => res_a[0].to_i }

  inp = tmp[0].split(', ').map do |i|
    i_a = i.split(' ')
    i = { i_a[1] => i_a[0].to_i }
  end

  r = {
    'i' => inp,
    'r' => res
  }
end

leftovers = Hash.new(0)
total_ores = 1_000_000_000_000

f = 0

loop do
  res = components(reactions, 'FUEL', 1, leftovers)

  leftovers = res[1]
  total_ores -= res[0]

  break if total_ores < 0
  f += 1
end

puts f
