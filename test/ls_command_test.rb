# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../07.ls_object/ls_command'

class LsCommandTest < Minitest::Test
  def setup
    @format = LsShort.new(50)
  end

  def test_run_with_multiple_directories
    expected = <<~TEXT
      ./test/ls_short_test_files/:
      123456789  defghijk   z          zzzzz
      56789      directory  zz         zzzzzz
      9999       ls.rb      zzz
      abc        qwertfdsdf zzzz

      ./test/ls_short_test_files/:
      123456789  defghijk   z          zzzzz
      56789      directory  zz         zzzzzz
      9999       ls.rb      zzz
      abc        qwertfdsdf zzzz
    TEXT
    path1 = Pathname('./test/ls_short_test_files/')
    path2 = Pathname('./test/ls_short_test_files/')
    paths = [path1, path2]
    options = { long_format: false, dot_match: false }
    command = LsCommand.new(paths, options)
    command.instance_variable_set(:@format, LsShort.new(50))
    assert_output(expected) { command.run }
  end

  def test_run_long
    expected = <<~TEXT
      合計 4
      -rw-r--r-- 1 migi migi 5  9月 11 00:11 test.txt
      lrwxrwxrwx 1 migi migi 8  9月 11 00:21 text_link
    TEXT
    options = { long_format: true, dot_match: false }

    path = Pathname('./test/files')
    paths = [path]
    command = LsCommand.new(paths, options)
    assert_output(expected) { command.run }
  end
end
