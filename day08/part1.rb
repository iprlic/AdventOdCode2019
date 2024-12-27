#!/usr/bin/env ruby

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

pixels = input.scan(/\d/)

pix_per_layer = 25 * 6

pix_count = 0

min_zeros = pix_per_layer
ones_times_twos = 0

layer = {}
pixels.each do |p|
  layer[p] = layer[p] ? layer[p] + 1 : 1

  pix_count += 1
  next unless pix_count == pix_per_layer

  if layer['0'] < min_zeros
    min_zeros = layer['0']
    ones_times_twos = layer['1'] * layer['2']
  end

  pix_count = 0
  layer = {}
end

puts ones_times_twos
