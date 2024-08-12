# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../07.ls_object/file_entry'

class FileEntryTest < Minitest::Test
  def test_ls_long
    expected_stats = <<~TEXT.chomp
      -rw-r--r-- 1 kutimiti kutimiti 2698  7月 27 21:36 ../fjord-books_app-2023/Gemfile
    TEXT
    expected_stats2 = <<~TEXT.chomp
      -rw-r--r-- 1 kutimiti kutimiti  258  7月 27 21:28 ../fjord-books_app-2023/Rakefile
    TEXT
    file = FileEntry.new(Pathname('../fjord-books_app-2023/Gemfile'), called_from_dir: false)
    file2 = FileEntry.new(Pathname('../fjord-books_app-2023/Rakefile'), called_from_dir: false)
    entries = [file, file2]
    max_sizes = %i[nlink user group size].map do |key|
      entries.map(&:stats).map { |data| data[key].size }.max
    end
    assert_equal expected_stats, file.run_ls_long(max_sizes)
    assert_equal expected_stats2, file2.run_ls_long(max_sizes)
  end
end
