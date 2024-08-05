# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(game, first_mark, second_mark = nil, third_mark = nil)
    @game = game
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
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

    if !@game.frames[index + 1].second_shot.exist?
      [@game.frames[index + 1].first_shot, @game.frames[index + 2].first_shot].map(&:score).sum
    else
      [@game.frames[index + 1].first_shot, @game.frames[index + 1].second_shot].map(&:score).sum
    end
  end

  def spare_bonus
    index = @game.frames.find_index(self)
    return 0 if index == 9

    @game.frames[index + 1].first_shot.score
  end
end
