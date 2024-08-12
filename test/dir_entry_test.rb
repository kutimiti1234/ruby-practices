# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../07.ls_object/dir_entry'

class DirEntryTest < Minitest::Test
  def test_ls_long_if_target_is_file
    expected_stats = <<~TEXT.chomp
      -rw-r--r--  1 kutimiti kutimiti      2698  7月 27 21:36 Gemfile
      -rw-r--r--  1 kutimiti kutimiti      8287  7月 27 21:36 Gemfile.lock
      -rw-r--r--  1 kutimiti kutimiti      4014  7月 27 21:28 README.md
      -rw-r--r--  1 kutimiti kutimiti       258  7月 27 21:28 Rakefile
      drwxr-xr-x 12 kutimiti kutimiti      4096  7月 27 21:28 app
      drwxr-xr-x  2 kutimiti kutimiti      4096  7月 27 21:28 bin
      drwxr-xr-x  5 kutimiti kutimiti      4096  7月 27 21:36 config
      -rw-r--r--  1 kutimiti kutimiti       160  7月 27 21:28 config.ru
      drwxr-xr-x  4 kutimiti kutimiti      4096  7月 27 21:43 db
      -rw-r--r--  1 kutimiti kutimiti 109166380  7月 23 08:52 google-chrome-stable_current_amd64.deb
      drwxr-xr-x  4 kutimiti kutimiti      4096  7月 27 21:28 lib
      drwxr-xr-x  2 kutimiti kutimiti      4096  7月 27 21:35 log
      drwxr-xr-x  2 kutimiti kutimiti      4096  7月 27 21:28 public
      drwxr-xr-x  2 kutimiti kutimiti      4096  7月 27 21:28 storage
      drwxr-xr-x 10 kutimiti kutimiti      4096  7月 27 21:28 test
      drwxr-xr-x  5 kutimiti kutimiti      4096  7月 27 21:35 tmp
      drwxr-xr-x  3 kutimiti kutimiti      4096  7月 27 21:28 vendor
    TEXT
    options = { dot_match: false }
    directory = DirEntry.new(Pathname('../fjord-books_app-2023/'), options)
    entries = directory.file_entries
    max_sizes = %i[nlink user group size].map do |key|
      entries.map(&:stats).map { |data| data[key].size }.max
    end
    assert_equal expected_stats, directory.run_ls_long(max_sizes)
  end

  def test_dir_total
    expected_total = 106_680
    options = { dot_match: false }
    directory = DirEntry.new(Pathname('../fjord-books_app-2023/'), options)
    assert_equal expected_total, directory.total
  end
end
