# ! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SHOW_ADJUST_SPACE_SIZE = 1
STANDARD_INPUT_EXCEPTIONAL_WORD = '-'
TOTAL = '合計'

def main
  options = parse_options(ARGV)
  counts = []
  ARGF.each(nil) do |input_text|
    count = {}

    count[:filename] = ARGF.filename
    count[:line] = input_text.lines.count if options[:l]
    count[:word] = input_text.split(/\s+/).size if options[:w]
    count[:bytesize] = input_text.size if options[:c]
    counts << count
  end
  rows = counts
  # 複数行出力する場合は、集計行を表示する
  rows << get_wc_total_row(counts) if counts.size > 1
  max_column_widths = get_max_column_widths(rows)
  show_wc_rows(rows, max_column_widths)
end

def get__total_row(counts)
  total_row = counts.inject({}) do |result, column_name|
    result.merge(column_name) { |_key, current_val, adding_value| current_val + adding_value }
  end
  total_row[:filename] = TOTAL
  total_row
end

def show_wc_rows(rows, max_column_widths)
  rows.each do |row|
    cells = {}
    row.each_pair do |column_name, cell|
      cells[column_name] = if column_name == :filename
                             # 標準入力を受け取る際に例外的に"-"が入力されるため除外する
                             cell unless cell == STANDARD_INPUT_EXCEPTIONAL_WORD
                           else
                             cell.to_s.rjust(max_column_widths[column_name] + SHOW_ADJUST_SPACE_SIZE)
                           end
    end
    puts "#{cells[:line]}#{cells[:word]}#{cells[:bytesize]} #{cells[:filename]}"
  end
end

def get_max_column_widths(wc_rows)
  max_lines_width = wc_rows.map { |entry| entry[:line].to_s.length  }.max
  max_words_width = wc_rows.map { |entry| entry[:word].to_s.length  }.max
  max_bytesizes_width = wc_rows.map { |entry| entry[:bytesize].to_s.length }.max
  { line: max_lines_width, word: max_words_width, bytesize: max_bytesizes_width }
end

def parse_options(argv)
  options = {}
  OptionParser.new do |opt|
    opt.on('-l') { |v| options[:l] = v }
    opt.on('-w') { |v| options[:w] = v }
    opt.on('-c') { |v| options[:c] = v }
    opt.parse!(argv)
  end

  if options.empty?
    options[:l] = true
    options[:w] = true
    options[:c] = true
  end
  options
end

main
