# frozen_string_literal: true

require 'pathname'
require_relative '../07.ls_object/ls_long'

options = { dot_match: false }

path = Pathname('../fjord-books_app-2023/')
path2 = Pathname('../fjord-books_app-2023/Gemfile')
paths = [path, path2]
command = LsLong.new(paths, options)
command.run
