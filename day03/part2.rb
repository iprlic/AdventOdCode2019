#!/usr/bin/env ruby

def line_to_points(line)
  points = [[[0, 0], 0]]
  steps_to_point = 0

  line.each do |l|
    direction = l[0]
    distance = l[1..-1].to_i

    distance.times do |d|
      last_point = points.last.first
      steps_to_point += 1
      case direction
      when 'R'
        points << [[last_point[0] + 1, last_point[1]], steps_to_point]
      when 'L'
        points << [[last_point[0] - 1, last_point[1]], steps_to_point]
      when 'U'
        points << [[last_point[0], last_point[1] + 1], steps_to_point]
      when 'D'
        points << [[last_point[0], last_point[1] - 1], steps_to_point]
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

intersections = first_line.map(&:first) & second_line.map(&:first)

intersection_distances = {}

first_line.each do |point|
  if intersections.include?(point.first) && !intersection_distances.has_key?(point.first)
    intersection_distances[point.first] = point[1]
  end
end

intersection_distances_summed = []
second_line.each do |point|
  if intersections.include?(point.first) && !intersection_distances_summed.include?(point.first)
    intersection_distances[point.first] += point[1]
    intersection_distances_summed << point[1]
  end
end

puts intersection_distances.values.min
