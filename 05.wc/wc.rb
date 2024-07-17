# ! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SEPARATOR_SIZE = 1
STDIN_FILENAME = '-'
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
  counts << calculate_counts_total(counts) if counts.size > 1
  max_column_widths = calculate_wc_max_column_widths(counts)
  show_wc_rows(counts, max_column_widths)
end

def calculate_counts_total(counts)
  counts_without_filename = counts.map { |count| count.except(:filename) }

  total = counts_without_filename.inject({}) do |result, count|
    result.merge(count) do |_key, current_val, adding_value|
      current_val + adding_value
    end
  end
  total[:filename] = TOTAL
  total
end

def show_wc_rows(rows, max_column_widths)
  rows.each do |row|
    cells = {}
    row.each do |column_name, cell|
      cells[column_name] = if column_name == :filename
                             cell unless cell == STDIN_FILENAME
                           else
                             column_width = max_column_widths[column_name] + SEPARATOR_SIZE
                             cell.to_s.rjust(column_width)
                           end
    end
    puts "#{cells[:line]}#{cells[:word]}#{cells[:bytesize]} #{cells[:filename]}"
  end
end

def calculate_wc_max_column_widths(rows)
  max_lines_width = rows.map { |entry| entry[:line].to_s.length }.max
  max_words_width = rows.map { |entry| entry[:word].to_s.length }.max
  max_bytesizes_width = rows.map { |entry| entry[:bytesize].to_s.length }.max
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
