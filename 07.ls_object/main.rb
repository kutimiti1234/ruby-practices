# frozen_string_literal: true

require 'io/console'
require_relative 'ls'

LS_SHORT_WIDTH = IO.console.winsize[1]
ls = Ls.new(LS_SHORT_WIDTH)
ls.run
