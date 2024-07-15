# ! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DDISPLAY_ADJUST_LENGTH = 1
TOTAL = '合計'

def main
  options = parse_options(ARGV)
  wc_count_results = []
  ARGF.each(nil) do |input_text|
    wc_count_result = {}

    wc_count_result[:filename] = ARGF.filename
    wc_count_result[:line] = input_text.lines.count if options[:l]
    wc_count_result[:word] = input_text.split(/\s+/).size if options[:w]
    wc_count_result[:bytesize] = input_text.size if options[:c]
    wc_count_results << wc_count_result
  end
  wc_results = wc_count_results
  # 複数行出力する場合は、集計行を表示する
  wc_results << get_total_row(wc_count_results) if wc_count_results.size > 2
  max_column_widths = get_max_column_widths(wc_results)
  show_wc_results(wc_results, max_column_widths)
end

def get_total_row(wc_count_results)
  total_row = wc_count_results.inject({}) do |result, wc_count_data|
    result.merge(wc_count_data) { |_key, current_val, adding_value| current_val + adding_value }
  end
  total_row[:filename] = TOTAL
  total_row
end

def show_wc_results(wc_results, max_column_widths)
  wc_results.each do |output_line|
    line = output_line[:line].to_s.rjust(max_column_widths[:line] + DDISPLAY_ADJUST_LENGTH) if output_line[:line]
    word = output_line[:word].to_s.rjust(max_column_widths[:word] + DDISPLAY_ADJUST_LENGTH) if output_line[:word]
    bytesize = output_line[:bytesize].to_s.rjust(max_column_widths[:bytesize] + DDISPLAY_ADJUST_LENGTH)
    filename = output_line[:filename]

    puts "#{line}#{word}#{bytesize} #{filename}"
  end
end

def get_max_column_widths(wc_results)
  max_lines_width = wc_results.map { |entry| entry[:line].to_s.length  }.max
  max_words_width = wc_results.map { |entry| entry[:word].to_s.length  }.max
  max_bytesizes_width = wc_results.map { |entry| entry[:bytesize].to_s.length }.max
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

  unless options.key?(:l) || options.key?(:w) || options.key?(:c)
    options[:l] = true
    options[:w] = true
    options[:c] = true
  end
  options
end

main
