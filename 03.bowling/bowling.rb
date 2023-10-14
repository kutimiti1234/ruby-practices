#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
# ありえない投球数、数字、記号が来ない前提
frames = shots.each_slice(2).to_a

point = 0
frames.each_with_index do |frame, index|
  next if index > 9

  point += frame.sum

  if frame[0] == 10 # strike
    # 2連続ストライクが発生した場合、2フレーム先の一投目を参照する。
    point += if frames[index.succ][0] == 10
               10 + frames[index.succ.succ][0]
             else
               frames[index.succ][0] + frames[index.succ][1]
             end
  elsif frame.sum == 10 # spare
    point += frames[index.succ][0]
  end
end
puts point
