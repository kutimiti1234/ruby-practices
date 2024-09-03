# frozen_string_literal: true

require_relative 'file_entry'
require_relative 'entries'

class FileEntriesList
  include Entries

  def initialize(entries, options)
    @options = options
    @file_entries = @options[:reverse] ? entries.sort_by { |entry| entry.stats[:name] }.reverse : entries.sort_by { |entry| entry.stats[:name] }
  end

  def run_ls_short(width)
    max_file_name_count = @file_entries.map { |f| f.stats[:name].size }.max
    col_count = width / (max_file_name_count + 1)
    row_count = col_count.zero? ? @file_entries.count : (@file_entries.count.to_f / col_count).ceil
    transposed_file_entries = safe_transpose(@file_entries.each_slice(row_count).to_a)
    format_table(transposed_file_entries, max_file_name_count)
  end

  def run_ls_long
    max_sizes = find_max_sizes
    @file_entries.map { |entry| entry.run_ls_long(max_sizes) }.join("\n")
  end
end
