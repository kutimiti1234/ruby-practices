# frozen_string_literal: true

require_relative 'entry'
require_relative 'file_entry'

class DirEntry < Entry
  attr_accessor :file_entries

  def initialize(path, options)
    super(path)
    @options = options
    @file_entries = collect_file_entries
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

  def find_max_sizes
    %i[nlink user group size].map do |key|
      @file_entries.map(&:stats).map { |data| data[key].size }.max
    end
  end

end
