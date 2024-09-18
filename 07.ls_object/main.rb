#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'
require_relative 'ls_command'

opt = OptionParser.new
options = { long_format: false, reverse: false, dot_match: false }
opt.on('-l') { |v| options[:long_format] = v }
opt.on('-r') { |v| options[:reverse] = v }
opt.on('-a') { |v| options[:dot_match] = v }
opt.parse!(ARGV)
paths = ARGV.empty? ? [Pathname('.')] : ARGV.map { |path| Pathname(path) }
command = LsCommand.new(paths, options)
command.run
