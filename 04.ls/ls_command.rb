#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
def parse_and_remove_options(argv)
  argv_options = {}
  OptionParser.new do |opt|
    opt.on('-a') { |v| argv_options[:a] = v }
    opt.on('-r') { |v| argv_options[:r] = v }
    opt.on('-l') { |v| argv_options[:l] = v }
    # argvからオプションを取り除く
    opt.parse!(argv)
  end
  argv_options
end

def parse_argv(argv)
  argv_directories = []
  argv_files = []
  argv_errors = []

  # argvにコマンド引数が指定されなかった場合カレントディレクトリを指定するようにする
  argv_directories << '.' if argv.empty?
  argv.each do |x|
    if File.directory?(x)
      argv_directories << x
    elsif File.file?(x)
      argv_files << x
    else
      argv_errors << x
    end
  end

  { directories: argv_directories, files: argv_files, errors: argv_errors }
end

def file_info(file)
  file_info = File.lstat(file)
  case file_info.ftype
  when 'direcotry'
    file_type = 'd'
  when  'file'
    file_type = '-'
  when  'link'
    file_type = 'l'
  end

  file_permissions = file_info.mode.to_s(8).rjust(6, '0')[3..5].chars.map do |c|
    rdx = if (c.to_i & 0b100).positive?
            'r'
          else
            '-'
          end +
          if (c.to_i & 0b010).positive?
            'w'
          else
            '-'
          end +
          if (c.to_i & 0b001).positive?
            'x'
          else
            '-'
          end
    rdx
  end.join

  file_type + file_permissions
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
ParseResult = Data.define(:options, :directories, :files, :errors)
argv_options = parse_and_remove_options(ARGV)
argv_arguments = parse_argv(ARGV)
commandline_arguments = ParseResult.new(options: argv_options, **argv_arguments)

if !commandline_arguments.errors.empty?
  commandline_arguments.errors.each do |error_argument|
    puts "ls: '#{error_argument}' にアクセスできません: そのようなファイルやディレクトリはありません。"
  end
end

# 引数にファイルを指定した場合、ディレクトリと区別して表示する
if !commandline_arguments.files.empty?
  if commandline_arguments.options[:l]
    p 'ひとまず'
  else
    files = commandline_arguments.files.sort.reverse if commandline_arguments.options[:r]
    files = organize_files(commandline_arguments.files, DISPLAY_MAX_LINE)
    files = convert_to_displayable_array(files)
    display_directory(files)
    puts ''

  end
end

commandline_arguments.directories.each do |path|
  if commandline_arguments.options[:l]
    p 'ひとまず'
  else

    puts "#{path}:" if (commandline_arguments.directories.size + commandline_arguments.files.size) > 1
    puts "#{path}:" if (commandline_arguments.directories.size + commandline_arguments.files.size) == 1 && !commandline_arguments.errors.empty?

    files = if commandline_arguments.options[:a]
              path = '.' if path.nil?
              Dir.foreach(path).sort
            else
              Dir.glob('*', base: path)
            end
    files = files.sort.reverse if commandline_arguments.options[:r]
    ordered_files = organize_files(files, DISPLAY_MAX_LINE)

    displayable_files = convert_to_displayable_array(ordered_files)

    display_directory(displayable_files)
    puts
  end
end
