# frozen_string_literal: true

require 'pathname'
require_relative 'ls_short'

    options = { dot_match: false }

    path1 =Pathname('02.calendar/calendar.rb')
    path2 =Pathname('01.fizzbuzz/fizzbuzz.rb')
    path3 =Pathname('07.ls_object/ls_long.rb')
    path4 =Pathname('03.bowling/bowling.rb')
    path5 =Pathname('04.ls/ls_command.rb')
    path6 =Pathname('07.ls_object/dir_entry.rb')
    path7 =Pathname('07.ls_object/ls_long.rb')
    path8 =Pathname('07.ls_object/ls_long.rb')
    path9 =Pathname('07.ls_object/main.rb')
    path10 =Pathname('07.ls_object/entry.rb')
    path11 =Pathname('07.ls_object/main.rb')
    paths = [ path1, path2, path3, path4, path5, path6, path7, path8, path9, path10, path11]
    width = 236
    command = LsShort.new(paths, options,width)
command.run
