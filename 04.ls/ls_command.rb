#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
def parse_argv_and_options(argv)
  argv_options = {}
  argv_files = []
  OptionParser.new do |opt|
    opt.on('-a') { |v| argv_options[:a] = v }
    argv_files = opt.parse(argv)
  end
  [argv_options, argv_files]
end

def validate_file_or_directory_existence(argv)
  return argv if argv.nil?

  exist_directory = []
  exist_file = []
  argv.each do |x|
    if File.directory?(x)
      exist_directory << x
    elsif File.file?(x)
      exist_file << x
    else
      puts "ls: '#{x}' にアクセスできません: そのようなファイルやディレクトリはありません。"
    end
  end
  # 引数にファイルを指定した場合、ディレクトリと区別して表示するためのロジック
  if !exist_file.nil?
    files = organize_files(exist_file, DISPLAY_MAX_LINE)
    files = convert_to_displayable_array(files)
    display_directory(files)
    puts ''
  end
  abort if exist_directory.last.nil?
  exist_directory
end

def organize_files(file_names, display_max_line)
  slice_number = [file_names.to_a.size.ceildiv(display_max_line), 1].max
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
  display_file_names_displayable.transpose.each_with_index do |cols, _row|
    cols.each_with_index do |cell, _col|
      print "#{cell}  "
    end
    puts ''
  end
end

DISPLAY_MAX_LINE = 3

options, argv = parse_argv_and_options(ARGV)

argv = argv.empty? ? [nil] : validate_file_or_directory_existence(argv)

argv.each do |path|
  puts "#{path}:" if argv.size > 1 || ARGV.size > 1
  files = if options[:a]
            path = '.' if path.nil?
            Dir.foreach(path).sort
          else
            Dir.glob('*', base: path).sort
          end
  ordered_files = organize_files(files, DISPLAY_MAX_LINE)

  displayable_files = convert_to_displayable_array(ordered_files)

  display_directory(displayable_files)
  puts
end
