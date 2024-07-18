# ! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

SEPARATOR_SIZE = 1
STDIN_FILENAME = '-'
TOTAL = '合計'

def main
  options = parse_options(ARGV)
  rows = []
  ARGF.each(nil) do |input_text|
    counts = {}

    counts[:filename] = ARGF.filename
    counts[:line] = input_text.lines.count if options[:l]
    counts[:word] = input_text.split(/\s+/).size if options[:w]
    counts[:byte] = input_text.size if options[:c]
    rows << counts
  end
  rows << calculate_total_rows(rows) if rows.size > 1
  max_widths = calculate_max_widths(rows)
  show_rows(rows, max_widths)
end

def calculate_total_rows(rows)
  total = rows.inject({}) do |result, count|
    result.merge(count) do |key, current_val, adding_value|
      current_val + adding_value unless key == :filename
    end
  end
  total[:filename] = TOTAL
  total
end

def show_rows(rows, max_column_widths)
  rows.each do |row|
    columns = {}
    row.each do |name, value|
      columns[name] = if name == :filename
                        value unless value == STDIN_FILENAME
                      else
                        column_width = max_column_widths[name]
                        value.to_s.rjust(column_width) + ' ' * SEPARATOR_SIZE
                      end
    end
    puts columns.values_at(:line, :word, :byte, :filename).join
  end
end

def calculate_max_widths(rows)
  max_lines_width = rows.map { |entry| entry[:line].to_s.length }.max
  max_words_width = rows.map { |entry| entry[:word].to_s.length }.max
  max_bytes_width = rows.map { |entry| entry[:byte].to_s.length }.max
  { line: max_lines_width, word: max_words_width, byte: max_bytes_width }
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
