# ! /usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

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
  total = rows.inject({}) do |result, counts|
    result.merge(counts) do |key, current_val, adding_value|
      current_val + adding_value unless key == :filename
    end
  end
  total[:filename] = TOTAL
  total
end

def show_rows(rows, max_widths)
  rows.each do |counts|
    columns = {}
    counts.each do |name, value|
      columns[name] = if name == :filename
                        value unless value == STDIN_FILENAME
                      else
                        width = max_widths[name]
                        value.to_s.rjust(width)
                      end
    end
    puts columns.values_at(:line, :word, :byte, :filename).join(' ')
  end
end

def calculate_max_widths(rows)
  max_widths = {}
  max_widths = %i[line word byte].to_h do |name|
    max_width = rows.map { |counts| counts[name].to_s.length }.max
    [name,max_width]
  end
  max_widths
end

def parse_options(argv)
  options = {}
  OptionParser.new do |opt|
    opt.on('-l') { |v| options[:l] = v }
    opt.on('-w') { |v| options[:w] = v }
    opt.on('-c') { |v| options[:c] = v }
    opt.parse!(argv)
  end

  options.empty? ? { l: true, w: true, c: true } : options
end

main
