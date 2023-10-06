# frozen_string_literal: true

require 'optparse'
require 'date'
opt = OptionParser.new
opt.on('-y')
opt.on('-m')

year = opt.parse!(ARGV)[0].to_i
month = opt.parse!(ARGV)[1].to_i

# binding.irb

First_day = Date.new(year, month, 1)
Last_day = Date.new(year, month, -1)

title = "#{First_day.month}月 #{First_day.year}"
puts title.center(20)
puts '日 月 火 水 木 金 土'
# 0が日曜日,,6が土曜日のハッシュをweekと定義する。
week = { 0 => '', 1 => '', 2 => ' ', 3 => ' ', 4 => ' ', 5 => ' ', 6 => ' ' }

Range.new(First_day, Last_day).each do |d|
  # 土曜日出ない限りweekに数字を入れる。
  week[d.wday] = if d != Date.today
                   d.day.to_s.rjust(2)
                 else
                   # 当日は背景色と文字色を反転する
                   "\e[7m#{d.day.to_s.rjust(2)}\e[0m"
                 end
  next unless d.saturday? || d == Last_day

  week.each_value do |value|
    print "#{value} "
  end
  # 週の改行
  puts ''
  # weekを初期化
  week = { 0 => '', 1 => '', 2 => ' ', 3 => ' ', 4 => ' ', 5 => ' ', 6 => ' ' }
end
