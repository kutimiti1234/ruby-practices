# frozen_string_literal: true

require 'io/console'
require_relative 'directory_entry'
require_relative 'ls_short'
require_relative 'ls_long'

class LsCommand
  def initialize(paths, options)
    @paths = paths
    @options = options
    @format = @options[:long_format] ? LsLong.new : LsShort.new
    @directories = @paths.map { |path| DirectoryEntry.new(path, @options) }
                         .sort_by(&:path)
                         .yield_self { |directories| @options[:reverse] ? directories.reverse : directories }
  end

  def run
    output = @directories.map do |dir_entry|
      header = "#{dir_entry.path}:" if @directories.count > 1
      body = "#{@format.run(dir_entry)}"
    [header,body].compact.join("\n")
    end.join("\n\n").rstrip

    puts output
  end
end
