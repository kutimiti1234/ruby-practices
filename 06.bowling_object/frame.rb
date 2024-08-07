# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot = Shot.new(nil), third_shot = Shot.new(nil))
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def score(next_frame = nil, frame_after_next = nil)
    basic = [@first_shot, @second_shot, @third_shot].map(&:score).sum
    if strike?
      basic + strike_bonus(next_frame, frame_after_next)
    elsif spare?
      basic + spare_bonus(next_frame)
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

  def strike_bonus(next_frame, frame_after_next)
    return 0 if next_frame.nil?

    if !next_frame.second_shot.exist?
      [next_frame, frame_after_next].map(&:first_shot).map(&:score).sum
    else
      [next_frame.first_shot, next_frame.second_shot].map(&:score).sum
    end
  end

  def spare_bonus(next_frame)
    return 0 if next_frame.nil?

    next_frame.first_shot.score
  end
end
