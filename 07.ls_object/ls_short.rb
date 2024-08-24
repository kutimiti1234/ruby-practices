# frozen_string_literal: true

require_relative 'dir_entry'
require_relative 'entry'
require_relative 'ls_command'

class LsShort < LsCommand
  def initialize(paths, options, width)
    super(paths, options)
    @width = width
  end

  def run
    render_files unless @file_entries.empty?
    puts if @file_entries.size.positive? && @dir_entries.size.positive?
    render_directories unless @dir_entries.empty?
  end

  private

  def render_files
    file_list = FileEntriesList.new(@file_entries, @options)
    puts file_list.run_ls_short(@width)
  end

  def render_directories
    @dir_entries.each do |dir_entry|
      puts "#{dir_entry.path}:" if dir_entry.path.directory? && (@dir_entries.size >= 2 || !@file_entries.empty?)
      puts dir_entry.run_ls_short(@width)
    end
  end

end
