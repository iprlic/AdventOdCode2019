#!/usr/bin/env ruby

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

pixels = input.scan(/\d/)

pix_per_layer = 25 * 6
pix_count = 0

image = Array.new(pix_per_layer) { '2' }

pixels.each do |p|
  image[pix_count] = p if image[pix_count] == '2' && p != '2'

  pix_count += 1
  pix_count = 0 if pix_count == pix_per_layer
end

pix_per_layer.times do |i|
  print image[i]
  print "\n" if i == 24 || (i-24).modulo(25).zero?
end
