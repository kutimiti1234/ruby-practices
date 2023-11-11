#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def check_file_or_directory_existence(argv)
  return argv if argv.nil?

  exist_file_ordirectory = []
  argv.each do |x|
    if !File.exist?(x)
      puts "ls: #{x} にアクセスできません: そのようなファイルやディレクトリはありません。"
    else
      exist_file_ordirectory << x
    end
  end
  exist_file_ordirectory
end

def organize_files(file_names, display_max_line)
  slice_number = if (file_names.to_a.size % display_max_line).zero?
                   [file_names.to_a.size / display_max_line, 1].max
                 else
                   file_names.to_a.size / display_max_line + 1
                 end
  file_names.each_slice(slice_number).to_a
end

def convert_to_displayable_array(display_file_names)
  return display_file_names if display_file_names.last.nil?

  # display_directoryで転地するために、転値可能な行列に編集する。
  display_file_names.last.fill('', display_file_names.last.size...display_file_names.first.size)
  # 列ごとの幅を列の最大文字数に合わせて決定する。
  display_file_names.map do |inner_array|
    max_words = inner_array.max_by(1, &:size).first.size
    inner_array.map do |element|
      element.ljust(max_words)
    end
  end
end

def display_directory(display_file_names_displayable)
  # 要件の表示順に合わせて転置させたものを一つづつ表示する。
  display_file_names_displayable.transpose.each_with_index do |cols, _row|
    cols.each_with_index do |cell, _col|
      print "#{cell}  "
    end
    puts ''
  end
end

DISPLAY_MAX_LINE = 3

argv = check_file_or_directory_existence(ARGV)

if ARGV.size == 1

  files = Dir.glob('*', base: argv[0]).sort

  ordered_files = organize_files(files, DISPLAY_MAX_LINE)

  ordered_files = convert_to_displayable_array(ordered_files)

  display_directory(ordered_files)
else
  argv.each do |argv|
    puts "#{argv}:"

    files = Dir.glob('*', base: argv).sort

    ordered_files = organize_files(files, DISPLAY_MAX_LINE)

    ordered_files = convert_to_displayable_array(ordered_files)

    display_directory(ordered_files)
    puts
  end

end
