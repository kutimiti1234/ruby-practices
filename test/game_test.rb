# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../06.bowling_object/game'

class GameTest < Minitest::Test
  def test_game_score_example1
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'])
    score_calculator = Game.new
    expected_score = 139
    assert_equal expected_score, score_calculator.score
  end

  def test_game_score_example2
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'])
    score_calculator = Game.new
    expected_score = 164
    assert_equal expected_score, score_calculator.score
  end

  def test_game_score_example3
    ARGV.replace(['0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'])
    score_calculator = Game.new
    expected_score = 107
    assert_equal expected_score, score_calculator.score
  end

  def test_game_score_example4
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'])
    score_calculator = Game.new
    expected_score = 134
    assert_equal expected_score, score_calculator.score
  end

  def test_game_score_example5
    ARGV.replace(['6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'])
    score_calculator = Game.new
    expected_score = 144
    assert_equal expected_score, score_calculator.score
  end

  def test_game_score_example6
    ARGV.replace(['X,X,X,X,X,X,X,X,X,X,X,X'])
    score_calculator = Game.new
    expected_score = 300
    assert_equal expected_score, score_calculator.score
  end

  def test_game_score_example7
    ARGV.replace(['X,X,X,X,X,X,X,X,X,X,X,2'])
    score_calculator = Game.new
    expected_score = 292
    assert_equal expected_score, score_calculator.score
  end

  def test_game_score_example8
    ARGV.replace(['X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'])
    score_calculator = Game.new
    expected_score = 50
    assert_equal expected_score, score_calculator.score
  end
end
