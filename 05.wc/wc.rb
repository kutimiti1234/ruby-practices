# ! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  argv_options = parse_and_remove_options(ARGV)
  while (input_text = ARGF.gets(nil))
    wc_info = []

    wc_info = { line: count_line(input_text) } if argv_options[:l]
    wc_info = { word: count_word(input_text) } if argv_options[:w]
    wc_info = { bytesize: input_text.size } if argv_options[:c]

    puts "#{wc_info[:line] || ''} #{wc_info[:word] || ''}  #{wc_info[:bytesize] || ''}"
  end
end

def count_line(line); end
def count_word(line); end

def parse_and_remove_options(argv)
  argv_options = {}
  OptionParser.new do |opt|
    opt.on('-l') { |v| argv_options[:l] = v }
    opt.on('-w') { |v| argv_options[:w] = v }
    opt.on('-c') { |v| argv_options[:c] = v }
    # argvからオプションを取り除く
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
