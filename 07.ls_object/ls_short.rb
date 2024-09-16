# frozen_string_literal: true

require "io/console"
class LsShort
  MAX_DISPLAY_WIDTH = IO.console.winsize[1]

  def run(entries)
    max_file_name_count = entries.file_entries.map { |f| f.name.size }.max
    col_count = MAX_DISPLAY_WIDTH / (max_file_name_count + 1)
    row_count = col_count.zero? ? entries.count : (entries.file_entries.count.to_f / col_count).ceil
    transposed_file_entries = safe_transpose(entries.file_entries.each_slice(row_count).to_a)
    format_table(transposed_file_entries, max_file_name_count)
  end

  def safe_transpose(nested_file_entries)
    nested_file_entries[0].zip(*nested_file_entries[1..]).map(&:compact)
  end

  def format_table(file_entries, max_file_name_size)
    file_entries.map do |row_file_entries|
      render_short_format_row(row_file_entries, max_file_name_size)
    end.join("\n")
  end

  def render_short_format_row(row_file_entries, max_file_name_size)
    row_file_entries.map do |file_entry|
      file_entry.name.ljust(max_file_name_size + 1)
    end.join.rstrip
  end
end
