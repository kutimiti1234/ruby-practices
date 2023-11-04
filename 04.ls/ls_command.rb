#!/usr/bin/env ruby
# frozen_string_literal: true

def file_names_formatter(file_names, display_max_line)
  # 最大表示幅を考慮に入れながら列ごとの表示するファイルの位置を決定する。
  (file_names.to_a.size / display_max_line..file_names.to_a.size).each do |x|
    display_file_names = file_names.each_slice(x).to_a
    return display_file_names if file_names.each_slice(x).to_a.size <= display_max_line
  end
end

def file_names_make_displayable(display_file_names)
  # directory_displayで転地するために、転値可能な行列に編集する。
  display_file_names.last.fill('', display_file_names.last.size...display_file_names.first.size)
  # 列ごとに最大文字数似合わせて幅を作る。
  display_file_names.map! do |inner_array|
    max_words = inner_array.max_by(1, &:size).first.size
    inner_array.map! do |element|
      element.ljust(max_words)
    end
  end
end

def directory_display(display_file_names_displayable)
  # 要件の表示順に合わせて転地させたものを一つづつ表示する。
  display_file_names_displayable.transpose.each_with_index do |cols, _row|
    cols.each_with_index do |cell, _col|
      print "#{cell}  "
    end
    puts ''
  end
end

a = Dir.foreach('.').sort
display_max_line = 15

b = file_names_formatter(a, display_max_line)

p file_names_make_displayable(b)

p b

directory_display(b)
