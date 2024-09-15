# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'io/console'
require_relative '../07.ls_object/dir_entry'

class DirEntryTest < Minitest::Test
  def test_dir_total
    expected_total = 4
    options = { dot_match: false }
    directory = DirEntry.new(Pathname('test/files/'), options)
    assert_equal expected_total, directory.total
  end
end
