# frozen_string_literal: true

require_relative 'dir_entry'
require_relative 'ls_command'

class LsLong < LsCommand
  def run
    render_files unless @file_entries.empty?
    puts if @file_entries.size.positive? && @dir_entries.size.positive?
    render_directories unless @dir_entries.empty?
  end

  private

  def render_files
    file_list = FileEntriesList.new(@file_entries, @options)
    puts file_list.run_ls_long
  end

  def render_directories
    @dir_entries.each do |dir_entry|
      puts "#{dir_entry.path}:" if @dir_entries.size > 1 || @file_entries.size.positive?
      puts dir_entry.run_ls_long
      puts if @dir_entries.size > 1
    end
  end
end
