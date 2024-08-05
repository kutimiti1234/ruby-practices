# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

STRIKE = 'X'

class Game
  attr_reader :frames

  def initialize
    @frames = parse_marks
  end

  def score
    @frames.map(&:score).sum
  end

  private

  def parse_marks
    pins = ARGV[0].split(',')
    frames = []
    9.times do
      rolls = pins.shift(2)
      if rolls.first == STRIKE
        frames << Frame.new(self, rolls.first)
        pins.unshift rolls.last
      else
        frames << Frame.new(self, *rolls)
      end
    end

    frames << Frame.new(self, *pins)
  end
end
