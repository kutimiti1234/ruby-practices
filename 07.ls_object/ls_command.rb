# frozen_string_literal: true

require 'io/console'
require_relative 'file_entries_list'
require_relative 'dir_entry'

SHORT_FORMAT_WHOLE_WIDTH = IO.console.winsize[1]

class LsCommand
  def initialize(paths, options)
    @paths = paths
    @options = options
    @file_entries, @dir_entries = split_files_and_dirs(paths)
  end

  def run
    if @options[:long_format]
      run_ls_long
    else
      run_ls_short
    end
  end

  private

  def run_ls_short
    render_files_short unless @file_entries.empty?
    puts if @file_entries.size.positive? && @dir_entries.size.positive?
    render_directories_short unless @dir_entries.empty?
  end

  def run_ls_long
    render_files_long unless @file_entries.empty?
    puts if @file_entries.size.positive? && @dir_entries.size.positive?
    render_directories_long unless @dir_entries.empty?
  end

  def split_files_and_dirs(paths)
    files = []
    dirs  = []
    paths.each do |path|
      if path.file?
        files << FileEntry.new(path, called_from_dir: false)
      elsif path.directory?
        dirs << DirEntry.new(path, @options)
      end
    end
    sorted_dirs = @options[:reverse] ? dirs.sort_by(&:path).reverse : dirs.sort_by(&:path)
    [files, sorted_dirs]
  end

  def render_files_short
    file_list = FileEntriesList.new(@file_entries, @options)
    puts file_list.run_ls_short(SHORT_FORMAT_WHOLE_WIDTH)
  end

  def render_directories_short
    @dir_entries.each do |dir_entry|
      puts "#{dir_entry.path}:" if dir_entry.path.directory? && (@dir_entries.size >= 2 || !@file_entries.empty?)
      puts dir_entry.run_ls_short(SHORT_FORMAT_WHOLE_WIDTH)
      puts if @dir_entries.size > 1
    end
  end

  def render_files_long
    file_list = FileEntriesList.new(@file_entries, @options)
    puts file_list.run_ls_long
  end

  def render_directories_long
    @dir_entries.each do |dir_entry|
      puts "#{dir_entry.path}:" if @dir_entries.size > 1 || @file_entries.size.positive?
      puts dir_entry.run_ls_long
      puts if @dir_entries.size > 1
    end
  end
end
