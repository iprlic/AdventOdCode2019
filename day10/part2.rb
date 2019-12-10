#!/usr/bin/env ruby

def distance(a)
  Math.sqrt(a['x']**2 + a['y']**2)
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map(&:chars)

coords = input.map.with_index do |e, i|
  e.map.with_index do |f, j|
    { 'x' => j - 20, 'y' => 19 - i } if f == '#' # placing the station to center
  end.compact
end.compact.flatten

groups = {}

coords.each do |c|
  next if c['x'].zero? && c['y'].zero?

  ang = Math.atan2(c['x'], c['y'])

  ang += 2*Math::PI if ang < 0

  groups[ang] ||= []
  groups[ang] << c
end

groups = groups.sort.to_h

cnt = 0

groups.each { |k, g| groups[k] = g.sort { |a, b| distance(a) <=> distance(b) } }

loop do
  groups.each do |k, g|

    a = groups[k].shift
    next if a.nil?
    cnt += 1
    if cnt == 200
      puts ((a['x'] + 20) * 100) + (19 - a['y'])
      exit
    end
  end
end
