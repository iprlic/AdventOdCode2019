#!/usr/bin/env ruby

def line_to_points(line)
  points = [[0, 0]]

  line.each do |l|
    direction = l[0]
    distance = l[1..-1].to_i

    distance.times do |d|
      last_point = points.last
      case direction
      when 'R'
        points << [last_point[0] + 1, last_point[1]]
      when 'L'
        points << [last_point[0] - 1, last_point[1]]
      when 'U'
        points << [last_point[0], last_point[1] + 1]
      when 'D'
        points << [last_point[0], last_point[1] - 1]
      end
    end
  end

  points[1..-1]
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

lines = input.split("\n")

first_line = line_to_points(lines[0].split(','))
second_line = line_to_points(lines[1].split(','))

intersections = first_line & second_line

distances = intersections.map do |i|
  i[0].abs + i[1].abs
end

puts distances.min
