# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  attr_reader :frames

  def initialize
    @frames = parse_marks
  end

  def score
    @frames.map.with_index(1) do |frame, index|
      next_frames = frames.slice(index, 2)
      frame.score(*next_frames)
    end.sum
  end

  private

  def parse_marks
    pins = ARGV[0].split(',').map { |pin| Shot.new(pin) }
    frames = []
    9.times do
      rolls = pins.shift(2)
      if rolls.first.score == 10
        frames << Frame.new(rolls.first)
        pins.unshift rolls.last
      else
        frames << Frame.new(*rolls)
      end
    end

    frames << Frame.new(*pins)
  end
end
