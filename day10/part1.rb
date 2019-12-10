#!/usr/bin/env ruby

def obstruction(a, b, c)
  dxc = c['x'] - a['x']
  dyc = c['y'] - a['y']

  dxl = b['x'] - a['x']
  dyl = b['y'] - a['y']

  return false unless dxc * dyl - dyc * dxl == 0

  if dxl.abs >= dyl.abs
    return dxl > 0 ?
    a['x'] <= c['x'] && c['x'] <= b['x'] :
    b['x'] <= c['x'] && c['x'] <= a['x']
  end
  return dyl > 0 ?
    a['y'] <= c['y'] && c['y'] <= b['y'] :
    b['y'] <= c['y'] && c['y'] <= a['y']
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map(&:chars)

coords = input.map.with_index do |e, i|
  e.map.with_index do |f, j|
    { 'x' => j, 'y' => i } if f == '#'
  end.compact
end.compact.flatten

max_cnt = 0
max_coords = nil

coords.each do |c|
  cnt = 0
  coords.each do |v|
    next if v == c # don't check itself

    is_obstructed = false

    coords.each do |o|
      next if o == v || o == c

      if obstruction(c, v, o)
        is_obstructed = true
        break
      end
    end
    cnt += 1 unless is_obstructed
  end

  if cnt > max_cnt
    max_cnt = cnt
    max_coords = c
  end
end

puts max_coords
puts max_cnt
