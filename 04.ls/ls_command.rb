#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def determine_files_order(file_names, display_max_line)
  # 最大表示幅を考慮に入れながら列ごとの表示するファイルの位置を決定する。
  min_slice_number = if file_names.to_a.size / display_max_line < 1
                       1
                     else
                       file_names.to_a.size / display_max_line
                     end
  (min_slice_number..file_names.to_a.size).each do |x|
    display_file_names = file_names.each_slice(x).to_a
    return display_file_names if file_names.each_slice(x).to_a.size <= display_max_line
  end
end

def convert_to_displayable_array(display_file_names)
  # directory_displayで転地するために、転値可能な行列に編集する。
  display_file_names.last.fill('', display_file_names.last.size...display_file_names.first.size)
  # 列ごとの幅を列の最大文字数に合わせて決定する。
  display_file_names.map! do |inner_array|
    max_words = inner_array.max_by(1, &:size).first.size
    inner_array.map! do |element|
      element.ljust(max_words)
    end
  end
end

def directory_display(display_file_names_displayable)
  # 要件の表示順に合わせて転置させたものを一つづつ表示する。
  display_file_names_displayable.transpose.each_with_index do |cols, _row|
    cols.each_with_index do |cell, _col|
      print "#{cell}  "
    end
    puts ''
  end
end

files = Dir.glob('*', base: ARGV[0]).sort

display_max_line = 3

ordered_files = determine_files_order(files, display_max_line)

convert_to_displayable_array(ordered_files)

directory_display(ordered_files)
