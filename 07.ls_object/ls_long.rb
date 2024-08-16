# frozen_string_literal: true

require_relative '../07.ls_object/dir_entry'
require_relative '../07.ls_object/entry'
require_relative '../07.ls_object/ls_command.rb'


class LsLong < LsCommand

  def run
    render_files unless @file_entries.empty?
    render_directories  unless @dir_entries.empty?
  end

  private

  def find_max_sizes(entries)
    %i[nlink user group size].map do |key|
      entries.map(&:stats).map { |data| data[key].size }.max
    end
  end

  def render_files
    file_max_sizes = find_max_sizes(@file_entries)
    @file_entries.each do |entry|
      render(entry, file_max_sizes)
    end
  end

  def render_directories
    @dir_entries.each do |dir_entry|
      puts if @dir_entries.size >= 2 || !@file_entries.empty?
      file_max_sizes = find_max_sizes(dir_entry.file_entries)
      render(dir_entry, file_max_sizes)
    end
  end

  def render(entry, max_sizes)
    puts "#{entry.path}:" if entry.path.directory? && (@dir_entries.size >= 2 || !@file_entries.empty?)
    puts "合計 #{entry.total}" if entry.path.directory?
    puts entry.run_ls_long(max_sizes)
  end
end
