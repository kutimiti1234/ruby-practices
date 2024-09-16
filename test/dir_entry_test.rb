# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'io/console'
require_relative '../07.ls_object/directory_entry'

class DirEntryTest < Minitest::Test
  def test_dir_total
    expected_total = 4
    options = { dot_match: false }
    directory = DirectoryEntry.new(Pathname('test/files/'), options)
    assert_equal expected_total, directory.total
  end
end
