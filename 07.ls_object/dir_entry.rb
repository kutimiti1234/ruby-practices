# frozen_string_literal: true

require_relative 'entry'
require_relative 'file_entry'

class DirEntry < Entry
  attr_accessor :file_entries

  def initialize(path, options)
    super(path)
    @options = options
    @file_entries = parse_entries
  end

  def run_ls_long(max_sizes)
    @file_entries.map { |entry| entry.run_ls_long(max_sizes) }.join("\n")
  end

  def total
    @file_entries.map(&:stats).sum { |data| data[:blocks] }.to_i
  end

  private

  def parse_entries
    pattern = @path.join('*')
    params = @options[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    Dir.glob(*params).map { |file| FileEntry.new(file, called_from_dir: true) }
  end
end
