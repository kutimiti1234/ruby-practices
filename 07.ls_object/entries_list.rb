# frozen_string_literal: true

module EntriesList
  private

  def find_max_sizes
    %i[nlink user group size].map do |key|
      @file_entries.map(&:stats).map { |data| data[key].size }.max
    end
  end

  def safe_transpose(nested_file_entries)
    nested_file_entries[0].zip(*nested_file_entries[1..])
  end

  def format_table(file_entries, max_file_name_size)
    file_entries.map do |row_file_entries|
      render_short_format_row(row_file_entries, max_file_name_size)
    end.join("\n")
  end

  def render_short_format_row(row_file_entries, max_file_name_size)
    row_file_entries.map do |file_entry|
      file_entry.run_ls_short(max_file_name_size) unless file_entry.nil?
    end.join.rstrip
  end
end
