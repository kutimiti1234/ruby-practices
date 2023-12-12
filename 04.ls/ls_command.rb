#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
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

def file_mode_drx(file_stat)
  file_type_lookup = {
    'directory' => 'd',
    'file' => '-',
    'link' => 'l'
  }

  file_type = file_type_lookup[file_stat.ftype]
  file_permissions = file_stat.mode.to_s(8).rjust(6, '0')[3..5].chars.map do |c|
    rwx = %w[- x w . r]
    rwx[c.to_i & 0b100] + rwx[c.to_i & 0b010] + rwx[c.to_i & 0b001]
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
  files = if commandline_arguments.options[:r]
            commandline_arguments.files.sort.reverse
          else
            commandline_arguments.files
          end

  if commandline_arguments.options[:l]
    files.each do |file|
      file_stat = File.lstat(file)
      mode = file_mode_drx(file_stat)
      nlink = file_stat.nlink
      uid = Etc.getpwuid(file_stat.uid).name
      gid = Etc.getpwuid(file_stat.gid).name
      ctime = file_stat.ctime.strftime('%m月 %d %H:%M')
      puts "#{mode} #{nlink} #{uid} #{gid} #{file_stat.size} #{ctime} #{file}"
    end
  else
    files = organize_files(files, DISPLAY_MAX_LINE)
    files = convert_to_displayable_array(files)
    display_directory(files)

  end
  puts ''
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
