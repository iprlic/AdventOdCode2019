#!/usr/bin/env ruby

def build_chain(body, orbits, chain)
  orbits.each do |o|
    if o[1] == body
      chain.push(o[0])
      build_chain(o[0], orbits, chain)
    end
  end
end

def transfers(chain, intersection)
  cnt = 0
  chain.each do |o|
    cnt += 1
    break if o == intersection
  end

  cnt
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

all_orbits = input.split("\n").map { |o| o.split(')') }

san = 'SAN'
you = 'YOU'

san_chain = []
you_chain = []

all_orbits.each do |o|
  build_chain(o[0], all_orbits, san_chain) if o[1] == san
  build_chain(o[0], all_orbits, you_chain) if o[1] == you
end

intersection = (san_chain & you_chain).first

puts transfers(san_chain, intersection) + transfers(you_chain, intersection)
