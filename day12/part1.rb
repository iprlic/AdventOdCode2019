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

1000.times do
  (0..2).each do |i|
    ((i + 1)..3).each do |j|
      (0..2).each do |x|
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
  end

  moons.each do |m|
    (0..2).each do |x|
      m.position[x] += m.velocity[x]
    end
  end
end

energy = 0
moons.each do |m|
  energy += m.position.map(&:abs).inject(&:+) * m.velocity.map(&:abs).inject(&:+)
end

puts energy
