require 'date'
first_day = Date.new(2010,5,1)
Last_day= Date.new(2010,5,-1)

Range.new(first_day,Last_day ).each do  |d|
  puts " " if d.saturday?
  print d.day.to_s.rjust(02) + ' '
end
