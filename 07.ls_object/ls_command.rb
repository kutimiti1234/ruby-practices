# frozen_string_literal: true

require 'io/console'
require_relative 'dir_entry'
require_relative 'ls_short'
require_relative 'ls_long'

SHORT_FORMAT_WHOLE_WIDTH = IO.console.winsize[1]

class LsCommand
  def initialize(paths, options)
    @paths = paths
    @options = options
    @format = @options[:long_format] ? LsLong.new : LsShort.new
    @directories = @paths.map { |path| DirEntry.new(path, @options) }
                         .sort_by(&:path)
                         .tap { |directories| @options[:reverse] ? directories.reverse : directories }
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
    return if @directories.empty?

    @directories.each do |dir_entry|
      puts @format.run(dir_entry)
      puts
    end
  end

  def run_ls_long
    return if @directories.empty?

    @directories.each do |dir_entry|
      puts @format.run(dir_entry)
      puts
    end
  end
end
