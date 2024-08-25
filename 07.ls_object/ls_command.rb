# frozen_string_literal: true

require_relative 'file_entries_list'

class LsCommand
  def initialize(paths, options)
    @paths = paths
    @options = options
    @file_entries, @dir_entries = split_files_and_dirs(paths)
  end

  def run
    raise NotImplementedError, 'This method should be overridden by subclasses'
  end

  private

  def split_files_and_dirs(paths)
    files = []
    dirs  = []
    paths.each do |path|
      if path.file?
        files << FileEntry.new(path, called_from_dir: false)
      elsif path.directory?
        dirs << DirEntry.new(path, @options)
      end
    end
    dirs = dirs.sort_by(&:path)
    dirs = dirs.reverse if @options[:reverse]
    [files, dirs]
  end

  def render_files
    raise NotImplementedError, 'This method should be overridden by subclasses'
  end

  def render_directories
    raise NotImplementedError, 'This method should be overridden by subclasses'
  end

  def render
    raise NotImplementedError, 'This method should be overridden by subclasses'
  end
end
