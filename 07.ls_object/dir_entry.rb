# frozen_string_literal: true

require_relative 'file_entry'

class DirEntry
  attr_accessor :path, :file_entries

  def initialize(path, options)
    @path = path
    @options = options
    @file_entries = collect_file_entries
  end

  def find_max_sizes
    %i[nlink user group size].to_h do |key|
      [key, @file_entries.map { |entry| entry.send(key).size }.max]
    end
  end

  def total
    @file_entries.map(&:blocks).sum
  end

  private

  def collect_file_entries
    pattern = @path.join('*')
    params = @options[:dot_match] ? [pattern, File::FNM_DOTMATCH] : [pattern]
    file_entries = Dir.glob(*params).map { |file| FileEntry.new(file) }.sort_by(&:name)
    @options[:reverse] ? file_entries.reverse : file_entries
  end
end
