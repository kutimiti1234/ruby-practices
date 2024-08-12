# frozen_string_literal: true

require 'etc'
require_relative 'entry'

BLOCK_SIZE = 1024
FILE_TYPE_LOOKUP = {
  'directory' => 'd',
  'file' => '-',
  'link' => 'l'
}.tap { |h| h.default = '-' }.freeze

class FileEntry < Entry
  attr_reader :stats

  def initialize(path, called_from_dir: false)
    super(path)
    @called_from_dir = called_from_dir
    @stats = parse_stats
  end

  def run_ls_long(max_sizes)
    format_row(@stats, *max_sizes)
  end

  private

  def parse_stats
    stats = File.lstat(@path)
    mode =  change_mode_drx(stats)
    nlink = stats.nlink.to_s
    user =  Etc.getpwuid(stats.uid).name
    group = Etc.getgrgid(stats.gid).name
    size = stats.size.to_s
    mtime = stats.mtime.strftime('%-m月 %e %H:%M')
    name = @called_from_dir ? File.basename(@path) : @path

    # File::statのブロックサイズの単位は512bytesであるから変換する
    block_size = stats.blocks * (512 / BLOCK_SIZE.to_f)

    { type_and_mode: mode, nlink:, user:, group:, size:, mtime:, name:,
      blocks: block_size }
  end

  def change_mode_drx(stats)
    file_type = FILE_TYPE_LOOKUP[stats.ftype]
    file_permissions = stats.mode.to_s(8).rjust(6, '0')[3..5].chars.map do |c|
      rwx = %w[- x w . r]
      rwx[c.to_i & 0b100] + rwx[c.to_i & 0b010] + rwx[c.to_i & 0b001]
    end.join

    file_type + file_permissions
  end

  def format_row(data, max_nlink, max_user, max_group, max_size)
    [
      data[:type_and_mode],
      " #{data[:nlink].rjust(max_nlink)}",
      " #{data[:user].ljust(max_user)}",
      " #{data[:group].ljust(max_group)}",
      " #{data[:size].rjust(max_size)}",
      "  #{data[:mtime]}",
      " #{data[:name]}"
    ].join
  end
end
