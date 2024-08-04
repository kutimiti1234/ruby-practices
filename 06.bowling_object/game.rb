# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

STRIKE = 10

class Game
  attr_reader :frames

  def initialize
    @frames = []
  end

  def score
    input_shots
    calculate_basic_score + calculate_bonus_score
  end

  def parse_marks
    marks = ARGV[0]
    pins = marks.split(',').map { |shot| Shot.new(shot) }

    9.times do
      rolls = pins.shift(2)
      if rolls.first.score == STRIKE
        frames << Frame.new(rolls.first)
        pins.unshift rolls.last
      else
        frames << Frame.new(*rolls)
      end
    end

    frames << Frame.new(*pins)
  end

  def calculate_basic_score; end

  def calculate_bonus_score; end
end
