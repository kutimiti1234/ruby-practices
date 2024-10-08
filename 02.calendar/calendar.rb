#! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'date'

params = ARGV.getopts('y:', 'm:')
year = if params['y'].nil?
         Date.today.year.to_i
       else
         params['y'].to_i
       end

month = if params['m'].nil?
          Date.today.month.to_i
        else
          params['m'].to_i
        end

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)

title = "#{month}月 #{year}"
puts title.center(20)
puts '日 月 火 水 木 金 土'
# 0が日曜日,,6が土曜日のハッシュをweekと定義する。
week = {}
7.times { |i| week[i] = nil }

Range.new(first_day, last_day).each do |d|
  # 土曜日出ない限りweekに数字を入れる。
  week[d.wday] = if d != Date.today
                   d.day.to_s.rjust(2)
                 # 当日は背景色と文字色を反転する
                 else
                   "\e[7m#{d.day.to_s.rjust(2)}\e[0m"
                 end
  next unless d.saturday? || d == last_day

  week.each_value do |value|
    if value.nil?
      #  空白が、埋められていたら2+1文字分空白を出力
      print '   '
    else
      print "#{value} "
    end
  end
  # 週の改行
  puts ''
  # binding.irb
  # weekを初期化
  7.times { |i| week[i] = nil }
end
