# frozen_string_literal: true

require 'io/console'
require_relative 'dir_entry'

SHORT_FORMAT_WHOLE_WIDTH = IO.console.winsize[1]

class LsCommand
  def initialize(paths, options)
    @paths = paths
    @options = options
    @directories = @paths.map { |path| DirEntry.new(path, @options) }
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
    render_directories_short unless @directories.empty?
  end

  def run_ls_long
    render_directories_long unless @directories.empty?
  end

  def render_directories_short
    @directories.each do |dir_entry|
      puts dir_entry.run_ls_short(SHORT_FORMAT_WHOLE_WIDTH)
      puts if @directories.size > 1
    end
  end

  def render_directories_long
    @directories.each do |dir_entry|
      puts dir_entry.run_ls_long
    end
  end
end
