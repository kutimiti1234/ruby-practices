# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../07.ls_object/ls_long'

class LsLongTest < Minitest::Test
  def test_run_files
    expected = <<~TEXT
      -rw-r--r-- 1 kutimiti kutimiti 2698  7月 27 21:36 ../fjord-books_app-2023/Gemfile
      -rw-r--r-- 1 kutimiti kutimiti  258  7月 27 21:28 ../fjord-books_app-2023/Rakefile
    TEXT
    options = { dot_match: false }

    paths = [Pathname('../fjord-books_app-2023/Gemfile'), Pathname('../fjord-books_app-2023/Rakefile')]
    command = LsLong.new(paths, options)
    assert_output(expected) { command.run }
  end

  def test_run_directories
    expected = <<~TEXT
      合計 106680
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

    path = Pathname('../fjord-books_app-2023/')
    paths = [path]
    command = LsLong.new(paths, options)
    assert_output(expected) { command.run }
  end

  def test_run_files_directories
    expected = <<~TEXT
      -rw-r--r-- 1 kutimiti kutimiti 2698  7月 27 21:36 ../fjord-books_app-2023/Gemfile

      ../fjord-books_app-2023:
      合計 106680
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

    path = Pathname('../fjord-books_app-2023')
    path2 = Pathname('../fjord-books_app-2023/Gemfile')
    paths = [path, path2]
    command = LsLong.new(paths, options)
    assert_output(expected) { command.run }
  end
end
