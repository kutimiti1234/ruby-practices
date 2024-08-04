# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

STRIKE = 10

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
    pins = marks.split(',').map { |shot| Shot.new(shot) }

    9.times do
      rolls = pins.shift(2)
      if rolls.first.score == STRIKE
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

  def bonus_score; end
end
