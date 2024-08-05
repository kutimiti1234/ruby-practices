# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(game, first_shot, second_shot = nil, third_shot = nil)
    @game = game
    @first_shot = first_shot
    @second_shot = second_shot.nil? ? Shot.new(nil) : second_shot
    @third_shot = third_shot.nil? ? Shot.new(nil) : third_shot
  end

  def score
    basic = [@first_shot, @second_shot, @third_shot].map(&:score).sum
    if strike?
      basic + strike_bonus
    elsif spare?
      basic + spare_bonus
    else
      basic
    end
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    return false if strike?

    [@first_shot, @second_shot].map(&:score).sum == 10
  end

  private

  def strike_bonus
    index = @game.frames.find_index(self)
    return 0 if index == 9

    next_frame = @game.frames[index + 1]
    frame_after_next = @game.frames[index + 2]

    if !next_frame.second_shot.exist?
      [next_frame, frame_after_next].map(&:first_shot).map(&:score).sum
    else
      [next_frame.first_shot, next_frame.second_shot].map(&:score).sum
    end
  end

  def spare_bonus
    index = @game.frames.find_index(self)
    return 0 if index == 9

    @game.frames[index + 1].first_shot.score
  end
end
