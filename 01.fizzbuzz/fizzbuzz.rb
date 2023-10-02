#!/usr/bin/env ruby
def fizz_buzz(number)
  if number  %  15 ==  0
          puts "FizzBuzz"
  elsif number  %  5  ==  0
      puts "Buzz"
elsif number  %  3 ==  0
   puts "Fizz"
  else
      puts number
  end
end

x=ARGV[0].to_i
i=1
x.times do
  fizz_buzz(i)
  i = i.succ
end
