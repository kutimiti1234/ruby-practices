# frozen_string_literal: true

require 'etc'

FILE_TYPES = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'link' => 'l',
  'socket' => 's',
  'fifo' => 'p'
}.freeze
BLOCK_SIZE = 1024

class FileEntry
  attr_reader :path

  def initialize(path)
    @path = path
    @stat = File.lstat(@path)
  end

  def mode
    file_type = FILE_TYPES[@stat.ftype]
    file_permissions = @stat.mode.to_s(8).rjust(6, '0')[3..5].chars.map do |c|
      rwx = %w[- x w . r]
      rwx[c.to_i & 0b100] + rwx[c.to_i & 0b010] + rwx[c.to_i & 0b001]
    end.join

    file_type + file_permissions
  end

  def nlink
    @stat.nlink.to_s
  end

  def user
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size.to_s
  end

  def time
    @stat.mtime.strftime('%-m月 %e %H:%M')
  end

  def name
    File.basename(@path)
  end

  def blocks
    # File::statのブロックサイズの単位は512bytesであるから変換する
    @stat.blocks * (512 / BLOCK_SIZE.to_f)
  end
end
