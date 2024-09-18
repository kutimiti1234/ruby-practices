# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'io/console'
require_relative '../07.ls_object/long_formatter'
require_relative '../07.ls_object/directory_entry'

class DirEntryTest < Minitest::Test
  def test_ls_long_if_target_is_file
    expected = <<~TEXT.chomp
      合計 4
      -rw-r--r-- 1 migi migi 5  9月 11 00:11 test.txt
      lrwxrwxrwx 1 migi migi 8  9月 11 00:21 text_link
    TEXT
    options = { dot_match: false }
    directory = DirectoryEntry.new(Pathname('./test/files'), options)
    formatter = LongFormatter.new
    assert_equal expected, formatter.run(directory)
  end
end
