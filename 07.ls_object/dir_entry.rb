# frozen_string_literal: true

require_relative 'file_entry'
require_relative 'entries_list'

class DirEntry
  include EntriesList

  attr_accessor :path, :file_entries

  def initialize(path, options)
    @path = path
    @options = options
    @file_entries = collect_file_entries
  end

  def run_ls_short(width)
    max_file_name_count = @file_entries.map { |f| f.stats[:name].size }.max
    col_count = width / (max_file_name_count + 1)
    row_count = col_count.zero? ? @file_entries.count : (@file_entries.count.to_f / col_count).ceil
    transposed_file_entries = safe_transpose(@file_entries.each_slice(row_count).to_a)
    format_table(transposed_file_entries, max_file_name_count)
  end

  def run_ls_long
    body = ["合計 #{total}"]
    max_sizes = find_max_sizes
    [body, @file_entries.map { |entry| entry.run_ls_long(max_sizes) }.join("\n")].join("\n")
  end

  def total
    @file_entries.map(&:stats).sum { |data| data[:blocks] }.to_i
  end

  private

  def collect_file_entries
    pattern = @path.join('*')
    params = @options[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    Dir.glob(*params).map { |file| FileEntry.new(file, called_from_dir: true) }
  end
end
