# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'io/console'
require_relative '../07.ls_object/directory_entry'
require_relative '../07.ls_object/ls_short'

class DirEntryTest < Minitest::Test
  def test_ls_short
    expected = <<~TEXT.chomp
      123456789  defghijk   z          zzzzz
      56789      directory  zz         zzzzzz
      9999       ls.rb      zzz
      abc        qwertfdsdf zzzz
    TEXT
    options = { dot_match: false }
    directory = DirectoryEntry.new(Pathname('./test/ls_short_test_files'), options)
    command = LsShort.new
    LsShort.const_set(:MAX_DISPLAY_WIDTH, 50)
    assert_equal expected, command.run(directory)
  end

  def test_ls_short_all
    expected = <<~TEXT.chomp
      .          abc        qwertfdsdf zzzz
      123456789  defghijk   z          zzzzz
      56789      directory  zz         zzzzzz
      9999       ls.rb      zzz
    TEXT
    options = { dot_match: true, long_format: false }
    directory = DirectoryEntry.new(Pathname('./test/ls_short_test_files'), options)
    command = LsShort.new
    LsShort.const_set(:MAX_DISPLAY_WIDTH, 50)
    assert_equal expected, command.run(directory)
  end

  def test_ls_short_reverse
    expected = <<~TEXT.chomp
      zzzzzz     zz         directory  56789
      zzzzz      z          defghijk   123456789
      zzzz       qwertfdsdf abc
      zzz        ls.rb      9999
    TEXT
    options = { dot_match: false, reverse: true }
    directory = DirectoryEntry.new(Pathname('./test/ls_short_test_files'), options)
    command = LsShort.new
    LsShort.const_set(:MAX_DISPLAY_WIDTH, 50)
    assert_equal expected, command.run(directory)
  end
end
