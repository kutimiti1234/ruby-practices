# frozen_string_literal: true

require 'date'
first_day = Date.new(2023, 11, 1)
Last_day = Date.new(2023, 11, -1)

# 0が日曜日のハッシュをweekと定義する。
week = { 0 => '', 1 => '', 2 => ' ', 3 => ' ', 4 => ' ', 5 => ' ', 6 => ' ' }
Range.new(first_day, Last_day).each do |d|

  week[d.wday] = d.day
  next unless d.saturday? || d == Last_day

  # 土曜日出ない限りweekに数字を入れる。
  week.each_value do |key|
    print "#{key.to_s.rjust(2)} "
  end
  puts ''
  week = { 0 => '', 1 => '', 2 => ' ', 3 => ' ', 4 => ' ', 5 => ' ', 6 => ' ' }
end
