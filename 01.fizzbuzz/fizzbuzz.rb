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

20.times do |i|
  fizz_buzz(i + 1)
end
