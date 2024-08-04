# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../06.bowling_object/shot'

class ShotTest < Minitest::Test
  def test_shot_score
    shot = Shot.new('9')
    expect = 9
    assert_equal expect, shot.score
  end

  def test_shot_score_of_strike
    shot = Shot.new('X')
    expect = 10
    assert_equal expect, shot.score
  end
end
