# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../07.ls_object/file_entry'

class FileEntryTest < Minitest::Test
  def test_monde_file
    expected_mode = <<~TEXT.chomp
      -rw-r--r--
    TEXT
    file = FileEntry.new(Pathname('./test/files/test.txt'))
    assert_equal expected_mode, file.mode
  end

  def test_monde_directory
    expected_mode = <<~TEXT.chomp
      drwxr-xr-x
    TEXT
    file = FileEntry.new(Pathname('./test/files'))
    assert_equal expected_mode, file.mode
  end

  def test_monde_link
    expected_mode = <<~TEXT.chomp
      lrwxrwxrwx
    TEXT
    file = FileEntry.new(Pathname('./test/files/text_link'))
    assert_equal expected_mode, file.mode
  end

  def test_nlink
    expected_mode = <<~TEXT.chomp
      1
    TEXT
    file = FileEntry.new(Pathname('./test/files/test.txt'))
    assert_equal expected_mode, file.nlink
  end

  def test_user
    expected_mode = <<~TEXT.chomp
      migi
    TEXT
    file = FileEntry.new(Pathname('./test/files/test.txt'))
    assert_equal expected_mode, file.user
  end

  def test_group
    expected_mode = <<~TEXT.chomp
      migi
    TEXT
    file = FileEntry.new(Pathname('./test/files/test.txt'))
    assert_equal expected_mode, file.group
  end

  def test_size
    expected_mode = <<~TEXT.chomp
      5
    TEXT
    file = FileEntry.new(Pathname('./test/files/test.txt'))
    assert_equal expected_mode, file.size
  end

  def test_time
    expected_mode = <<~TEXT.chomp
      9月 11 00:11
    TEXT
    file = FileEntry.new(Pathname('./test/files/test.txt'))
    assert_equal expected_mode, file.time
  end

  def test_mode
    expected_mode = <<~TEXT.chomp
      test.txt
    TEXT
    file = FileEntry.new(Pathname('./test/files/test.txt'))
    assert_equal expected_mode, file.name
  end
end
