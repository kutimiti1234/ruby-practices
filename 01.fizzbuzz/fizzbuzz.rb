#!/usr/bin/env ruby
# frozen_string_literal: true

def fizz_buzz(number)
  if (number % 15).zero?
    puts 'FizzBuzz'
  elsif (number % 5).zero?
    puts 'Buzz'
  elsif (number % 3).zero?
    puts 'Fizz'
  else
    puts number
  end
end

x = ARGV[0].to_i
Index = 1
x.times do
  fizz_buzz(i)
  Index = Index.succ
end
