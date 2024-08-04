# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../06.bowling_object/frame'

class FrameTest < Minitest::Test
  def test_frame_score
    first_shot_score = '9'
    second_shot_score = '1'
    expected_score = 10
    frame = Frame.new(first_shot_score, second_shot_score)
    assert_equal expected_score, frame.score
  end

  def test_frame_score_of_strike
    first_shot_score = 'X'
    frame = Frame.new(first_shot_score)
    expected_score = 10
    assert_equal expected_score, frame.score
  end

  def test_frame_score_of_three_shots
    first_shot_score = 'X'
    second_shot_score = 'X'
    third_shot_score =  'X'
    expected_score = 30
    frame = Frame.new(first_shot_score, second_shot_score, third_shot_score)
    assert_equal expected_score, frame.score
  end
end
