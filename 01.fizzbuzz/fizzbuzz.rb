#!/usr/bin/env ruby
(1..20).each do |print|
  case 
  when print % 3 == 0 && print % 5 == 0
    puts "FizzBuzz"
  when print % 3 == 0
    puts "Fizz"
  when print % 5 == 0
    puts "Buzz"
  else
   puts print
  end
end
