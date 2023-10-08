# frozen_string_literal: true


# !/usr/bin/env ruby
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
# 10フレーム目
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, index|
  # 10フレーム目だけ例外的な処理として行う。
  next unless index < 10

  point += frame.sum

  # ストライクの場合、あとの2投を点数に含むよう条件を設定
  if frame[0] == 10 # strike
    # ストライクが2連続で発生した場合,indexの2個後ろのフレームも参照できるよう処理
    point += if frames[index.succ][0] == 10
               10 + frames[index.succ.succ][0]
             # ストライクが2連続で発生しなかった場合、index1個後ろのフレームの一投目と2投目を代入
             else
               frames[index.succ][0] + frames[index.succ][1]
             end
  # スペアの場合、indexの1個後ろのフレームの1投目を代入
  elsif frame.sum == 10 # spare
    point += frames[index.succ][0]
  end

end
puts point
