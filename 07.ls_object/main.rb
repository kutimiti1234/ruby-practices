# frozen_string_literal: true

require 'pathname'
require_relative 'ls_short'

options = { dot_match: false }

path = Pathname('/dev/')
width = 236

command = LsShort.new([path],options,width)
command.run
