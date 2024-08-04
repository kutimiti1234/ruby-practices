# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = first_mark
    @second_shot = second_mark
    @third_shot = third_mark
  end

  def score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end
end
