#!/usr/bin/env ruby

def valid_password?(num)
  digits = num.to_s.scan(/\d/)

  add = 0

  (1..digits.length - 1).each do |i|
    # not ascendiiing
    return 0 if digits[i] < digits[i - 1]

    next unless add.zero? && digits[i] == digits[i - 1]

    group = true
    group = false if i > 1 && digits[i] == digits[i - 2]
    group = false if i < 5 && digits[i] == digits[i + 1]
    add = 1 if group
  end

  add
end

min = 240_920
max = 789_857

cnt = (min..max).inject(0) { |sum, n| sum += valid_password?(n) }

puts cnt
