# frozen_string_literal: true

require 'io/console'
require_relative 'directory_entry'
require_relative 'short_formatter'
require_relative 'long_formatter'

class LsCommand
  def initialize(paths, options)
    @paths = paths
    @options = options
    @formatter = @options[:long_format] ? LongFormatter.new : ShortFormatter.new
    @directories = @paths.map { |path| DirectoryEntry.new(path, @options) }
                         .sort_by(&:path)
                         .then { |directories| @options[:reverse] ? directories.reverse : directories }
  end

  def run
    output = @directories.map do |dir_entry|
      header = "#{dir_entry.path}:" if @directories.count > 1
      body = @formatter.run(dir_entry)
      [header, body].compact.join("\n")
    end.join("\n\n").rstrip

    puts output
  end
end
