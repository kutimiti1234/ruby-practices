# frozen_string_literal: true

require 'pathname'
require 'optparse'
require_relative 'ls_command'

class Ls
  def initialize
    # parse_optionsを先に実行せずにparse_pathsを実行すると不具合が発生する。
    options = parse_options
    paths = parse_paths

    @command = LsCommand.new(paths, options)
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
