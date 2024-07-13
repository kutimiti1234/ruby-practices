# ! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options(ARGV)
  output_texts = []
  ARGF.each(nil) do |input_text|
    wc_info = {}
    file_name = ARGF.filename
    wc_info[:filename] = file_name
    wc_info[:line] = input_text.lines.count if options[:l]
    wc_info[:word] = input_text.split(/\s+/).size if options[:w]
    wc_info[:bytesize] = input_text.size if options[:c]
    output_texts << wc_info
  end
  output_texts << file_total_info(output_texts) if output_texts.size > MULTIPLE_DISPLAY
  max_width = get_max_widths(output_texts)
  print_output(output_texts, max_width)
end

DDISPLAY_ADJUST_LENGTH = 1
MULTIPLE_DISPLAY = 1
TOTAL = '合計'

def file_total_info(output_texts)
  file_total_info = output_texts.flat_map(&:to_a).group_by(&:first).reject { |k, _v| k == :filename }
  file_total_info.transform_values { |value| value.map(&:last).sum }.merge(filename: TOTAL)
end

def print_output(output_text, max_width)
  output_text.each do |output_line|
    puts format_output_line(output_line, max_width)
  end
end

def format_output_line(output_line, max_width)
  line = output_line[:line]&.to_s&.rjust(max_width[:line])
  word = output_line[:word]&.to_s&.rjust(max_width[:word])
  bytesize = output_line[:bytesize]&.to_s&.rjust(max_width[:bytesize])
  filename = output_line[:filename] == '-' ? '' : output_line[:filename]

  "#{line}#{word}#{bytesize} #{filename}"
end

def get_max_widths(output_text)
  max_lines_width = output_text.map { |entry| entry[:line].to_s.length + DDISPLAY_ADJUST_LENGTH }.max
  max_words_width = output_text.map { |entry| entry[:word].to_s.length + DDISPLAY_ADJUST_LENGTH }.max
  max_bytesizes_width = output_text.map { |entry| entry[:bytesize].to_s.length + DDISPLAY_ADJUST_LENGTH }.max
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
