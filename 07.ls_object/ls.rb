# frozen_string_literal: true

require 'pathname'
require 'optparse'
require_relative 'ls_long'
require_relative 'ls_short'

class Ls
  def initialize(width)
    paths = parse_paths
  def initialize
    options = parse_options
    paths = parse_paths

    @command = if options[:long_format]
                 LsLong.new(paths, options)
               else
                 LsShort.new(paths, options, width)
               end
  end

  def run
    @command.run
  end

  private

  def parse_options
    opt = OptionParser.new
    options = { long_format: false, reverse: false, dot_match: false }
    opt.on('-l') { |v| options[:long_format] = v }
    opt.on('-r') { |v| options[:reverse] = v }
    opt.on('-a') { |v| options[:dot_match] = v }
    opt.parse!(ARGV)

    options
  end

  def parse_paths
    ARGV.empty? ? [Pathname('.')] : ARGV.map { |path| Pathname(path) }
  end
end
