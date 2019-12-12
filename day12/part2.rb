#!/usr/bin/env ruby

Moon = Struct.new(:position, :velocity)

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).strip

moons = input.split("\n").map do |m|
  spl = m
        .delete!('<')
        .delete!('>')
        .delete!('x=')
        .delete!('y=')
        .delete!('z=')
        .split(', ')

  position = [spl[0].to_i, spl[1].to_i, spl[2].to_i]
  velocity = [0, 0, 0]

  Moon.new(position, velocity)
end

periods = []

initial = Marshal.load(Marshal.dump(moons))

(0..2).each do |x|
  axis_period = 0
  cnt = 0
  loop do
    cnt += 1

    (0..2).each do |i|
      ((i + 1)..3).each do |j|
        if moons[i].position[x] > moons[j].position[x]
          moons[i].velocity[x] -= 1
          moons[j].velocity[x] += 1
        end
        if moons[i].position[x] < moons[j].position[x]
          moons[i].velocity[x] += 1
          moons[j].velocity[x] -= 1
        end
      end
    end

    moons.each_with_index do |m, k|
      moons[k].position[x] += moons[k].velocity[x]
    end

    if moons[0].position[x] == initial[0].position[x] &&
      moons[1].position[x] == initial[1].position[x] &&
      moons[2].position[x] == initial[2].position[x] &&
      moons[2].velocity[x] == initial[2].velocity[x] &&
      moons[1].velocity[x] == initial[1].velocity[x] &&
      moons[0].velocity[x] == initial[0].velocity[x]
      axis_period = cnt
    end

    break unless axis_period.zero?
  end

  periods << axis_period
end


puts periods.reduce(1, :lcm)

