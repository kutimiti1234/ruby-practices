# frozen_string_literal: true

require 'etc'

FILE_TYPE_LOOKUP = {
  'directory' => 'd',
  'file' => '-',
  'link' => 'l'
}.tap { |h| h.default = '-' }.freeze

class FileEntry
  attr_reader :path

  def initialize(path, called_from_dir: false)
    @path = path
    @called_from_dir = called_from_dir
    @stats = File.lstat(@path)
  end

  def mode?
    file_type = FILE_TYPE_LOOKUP[@stats.ftype]
    file_permissions = @stats.mode.to_s(8).rjust(6, '0')[3..5].chars.map do |c|
      rwx = %w[- x w . r]
      rwx[c.to_i & 0b100] + rwx[c.to_i & 0b010] + rwx[c.to_i & 0b001]
    end.join

    file_type + file_permissions
  end

  def nlink?
    @stats.nlink.to_s
  end

  def user?
    Etc.getpwuid(@stats.uid).name
  end

  def group?
    Etc.getgrgid(@stats.gid).name
  end

  def size?
    @stats.size.to_s
  end

  def time?
    @stats.mtime.strftime('%-m月 %e %H:%M')
  end

  def name?
    @called_from_dir ? File.basename(@path) : @path.to_s
  end
end
