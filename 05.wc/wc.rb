# ! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  argv_options = parse_and_remove_options(ARGV)
  output_text = []
  ARGF.each(nil) do |input_text|
    wc_info = []
    file_name = ARGF.filename
    wc_info << [:filename, file_name]
    wc_info << [:line, input_text.lines.count] if argv_options[:l]
    wc_info << [:word, input_text.split(/\s+/).size] if argv_options[:w]
    wc_info << [:bytesize, input_text.size] if argv_options[:c]
    output_text << wc_info.to_h
  end
  output_text << file_total_info(output_text)
  max_width = get_max_width(output_text)
  print_output(output_text, max_width)
end

DISPLAY_ADJUST_NUMBER = 1
TOTAL = '合計'

def file_total_info(output_text)
  file_total_info = output_text.flat_map(&:to_a).group_by(&:first).reject { |k, _v| k == :filename }
  file_total_info.transform_values { |value| value.map(&:last).sum }.merge(filename: TOTAL)
end

def print_output(output_text, max_width)
  output_text.each do |output_line|
    long_sentence = "#{output_line[:line]&.to_s&.rjust(max_width[:line_display_width])}"\
                    "#{output_line[:word]&.to_s&.rjust(max_width[:word_display_width])}"\
                    "#{output_line[:bytesize]&.to_s&.rjust(max_width[:bytesize_display_width])}"\
                    " #{output_line[:filename] == '-' ? nil : output_line[:filename]}"
    puts long_sentence
  end
end

def get_max_width(output_text)
  max_lines_width = output_text.map { |entry| entry[:line].to_s.length + DISPLAY_ADJUST_NUMBER }.max || 0
  max_words_width = output_text.map { |entry| entry[:word].to_s.length }.max + DISPLAY_ADJUST_NUMBER || 0
  max_bytesizes_width = output_text.map { |entry| entry[:bytesize].to_s.length + DISPLAY_ADJUST_NUMBER }.max || 0
  { line_display_width: max_lines_width, word_display_width: max_words_width, bytesize_display_width: max_bytesizes_width }
end

def parse_and_remove_options(argv)
  argv_options = {}
  OptionParser.new do |opt|
    opt.on('-l') { |v| argv_options[:l] = v }
    opt.on('-w') { |v| argv_options[:w] = v }
    opt.on('-c') { |v| argv_options[:c] = v }
    opt.parse!(argv)
  end

  unless argv_options.key?(:l) || argv_options.key?(:w) || argv_options.key?(:c)
    argv_options[:l] = true
    argv_options[:w] = true
    argv_options[:c] = true
  end
  argv_options
end

main
