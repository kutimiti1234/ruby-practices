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

  { directories: argv_directories.sort, files: argv_files.sort, errors: argv_errors }
end

def file_info(files, path = nil)
  file_infos = []
  files.each do |file|
    file_stat = File.lstat(File.expand_path(file, path))
    file_mode = file_mode_drx(file_stat)
    file_nlink = file_stat.nlink
    file_uid =  Etc.getpwuid(file_stat.uid).name
    file_gid =  Etc.getpwuid(file_stat.gid).name
    file_bytesize = file_stat.size
    file_mtime = file_stat.mtime.strftime('%m月 %e %H:%M')
    file_name = file

    # File::statのブロックサイズの単位は512bytesであるから変換する
    file_blocks = file_stat.blocks * (512 / BLOCK_SIZE.to_f)

    file_infos << { mode: file_mode, nlink: file_nlink, uid: file_uid, gid: file_gid, bytesize: file_bytesize, mtime: file_mtime, name: file_name,
                    block_size: file_blocks }
  end
  file_infos
end

def format_file_info(file_infos)
  file_infos[0].each_key do |key|
    max_width = file_infos.map { |hash| hash[key] }.map(&:to_s).max_by(1, &:size).first.size
    file_infos.size.times do |index|
      file_infos[index][key] = if key == :name
                                 file_infos[index][key].to_s.ljust(max_width, ' ')
                               else
                                 file_infos[index][key].to_s.rjust(max_width, ' ')
                               end
    end
  end
  file_infos
end

def display_with_l_option(formatted_file_infos)
  formatted_file_infos.size.times do |index|
    mode = formatted_file_infos[index][:mode]
    nlink = formatted_file_infos[index][:nlink]
    uid = formatted_file_infos[index][:uid]
    gid = formatted_file_infos[index][:gid]
    bytesize = formatted_file_infos[index][:bytesize]
    mtime = formatted_file_infos[index][:mtime]
    file = formatted_file_infos[index][:name]
    puts "#{mode} #{nlink} #{uid} #{gid} #{bytesize} #{mtime} #{file}"
  end
end

def file_mode_drx(file_stat)
  file_type = FILE_TYPE_LOOKUP[file_stat.ftype]
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
    puts
  end
end

DISPLAY_MAX_LINE = 3
BLOCK_SIZE = 1024
FILE_TYPE_LOOKUP = {
  'directory' => 'd',
  'file' => '-',
  'link' => 'l'
}.tap { |h| h.default = '-' }.freeze
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
            commandline_arguments.files.sort
          end

  if commandline_arguments.options[:l]
    file_infos = file_info(files)
    formatted_file_infos = format_file_info(file_infos)
    display_with_l_option(formatted_file_infos)
  else
    files = organize_files(files, DISPLAY_MAX_LINE)
    files = convert_to_displayable_array(files)
    display_directory(files)

  end
  puts
end

directories = if commandline_arguments.options[:r]
                commandline_arguments.directories.sort.reverse
              else
                commandline_arguments.directories
              end
directories.each do |path|
  puts "#{path}:" if (commandline_arguments.directories.size + commandline_arguments.files.size) > 1
  puts "#{path}:" if (commandline_arguments.directories.size + commandline_arguments.files.size) == 1 && !commandline_arguments.errors.empty?

  files = if commandline_arguments.options[:a]
            path = '.' if path.nil?
            Dir.foreach(path).sort
          else
            Dir.glob('*', base: path)
          end
  files = files.sort.reverse if commandline_arguments.options[:r]
  if commandline_arguments.options[:l]
    file_infos = file_info(files, path)
    formatted_file_infos = format_file_info(file_infos)
    puts "合計 #{formatted_file_infos.map { |hash| hash[:block_size].to_f }.sum.to_i}"
    display_with_l_option(formatted_file_infos)
  else
    ordered_files = organize_files(files, DISPLAY_MAX_LINE)

    displayable_files = convert_to_displayable_array(ordered_files)

    display_directory(displayable_files)
  end
  puts
end
