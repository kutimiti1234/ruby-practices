# frozen_string_literal: true

require 'io/console'
require_relative 'dir_entry'
require_relative 'ls_short'
require_relative 'ls_long'

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
    @directories.each do |dir_entry|
      puts "#{dir_entry.path}:" if @directories.count > 1
      puts @format.run(dir_entry)
      puts if @directories.count > 1
    end
  end
end
