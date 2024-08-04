# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

STRIKE = 'X'

class Game

  def initialize
    @frames = []
  end

  def score
    parse_marks
    basic_score + bonus_score
  end

  private

  def parse_marks
    marks = ARGV[0]
    pins = marks.split(',')

    9.times do
      rolls = pins.shift(2)
      if rolls.first == STRIKE
        @frames << Frame.new(rolls.first)
        pins.unshift rolls.last
      else
        @frames << Frame.new(*rolls)
      end
    end

    @frames << Frame.new(*pins)
  end

  def basic_score
    @frames.map(&:score).sum
  end

  def bonus_score
    bonus = 0
    9.times do |index|
      if @frames[index].strike?
        bonus += if !@frames[index + 1].second_shot.exist?
                   @frames[index + 1].first_shot.score + @frames[index + 2].first_shot.score
                 else
                   @frames[index + 1].first_shot.score + @frames[index + 1].second_shot.score
                 end
      elsif @frames[index].spare?
        bonus += @frames[index + 1].first_shot.score
      end
    end
    bonus
  end
end
