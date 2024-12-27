#!/usr/bin/env ruby

def valid_password?(num)
  digits = num.to_s.scan(/\d/)

  add = 0

  (1..digits.length - 1).each do |i|
    # not ascendiiing
    return 0 if digits[i] < digits[i - 1]

    next unless add.zero?

    add = 1 if digits[i] == digits[i - 1]
  end

  add
end

min = 284_639
max = 748_759

cnt = (min..max).inject(0) { |sum, n| sum += valid_password?(n) }

puts cnt
