# !/usr/bin/env ruby
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
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames.each_with_index do |frame, index|
  # 10投目だけ別の処理として行う。
  if index < 9
    point += frame.sum

    if frame[0] == 10 # strike
      point += if frames[index.succ][0] != 10
                 frames[index.succ][0] + frames[index.succ][1]
               else
                 10 + frames[index.succ.succ][0]
               end
    elsif frame.sum == 10 # spare
      point += frames[index.succ][0]
    end
  elsif index == 9
    point += frame.sum
    if frame[0] == 10
      point += if frames[index.succ][0] == 10
                 frames[index.succ].sum + frames[index.succ.succ][0]
               else
                 frames[index.succ].sum
               end
    elsif frame.sum == 10
      point += frames[index.succ][0]
    end

  end
end
puts point

# 1.10投目で３つ数字が入る可能性
# 2.配列の次の数字をどのように手に入れるか。
# 10投目はframes.sizでif文を作る。
#
