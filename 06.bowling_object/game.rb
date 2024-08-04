# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

STRIKE = 'X'

class Game
  def initialize
    @frames = parse_marks
  end

  def score
    calculate_basic_score + calculate_bonus_score
  end

  private

  def parse_marks
    pins = ARGV[0].split(',')
    frames = []
    9.times do
      rolls = pins.shift(2)
      if rolls.first == STRIKE
        frames << Frame.new(rolls.first)
        pins.unshift rolls.last
      else
        frames << Frame.new(*rolls)
      end
    end

    frames << Frame.new(*pins)
  end

  def calculate_basic_score
    @frames.map(&:score).sum
  end

  def calculate_bonus_score
    bonus = 0
    9.times do |index|
      bonus += calculate_strike_bonus(index) if @frames[index].strike?
      bonus += calculate_spare_bonus(index) if @frames[index].spare?
    end
    bonus
  end

  def calculate_strike_bonus(index)
    if !@frames[index + 1].second_shot.exist?
      [@frames[index + 1].first_shot, @frames[index + 2].first_shot].map(&:score).sum
    else
      [@frames[index + 1].first_shot, @frames[index + 1].second_shot].map(&:score).sum
    end
  end

  def calculate_spare_bonus(index)
    @frames[index + 1].first_shot.score
  end
end
