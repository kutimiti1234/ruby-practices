# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'io/console'
require_relative '../07.ls_object/dir_entry'

class DirEntryTest < Minitest::Test
  def test_ls_long_if_target_is_file
    expected_stats = <<~TEXT.chomp
      合計 106680
      -rw-r--r--  1 kutimiti kutimiti      2698  7月 27 21:36 Gemfile
      -rw-r--r--  1 kutimiti kutimiti      8287  7月 27 21:36 Gemfile.lock
      -rw-r--r--  1 kutimiti kutimiti      4014  7月 27 21:28 README.md
      -rw-r--r--  1 kutimiti kutimiti       258  7月 27 21:28 Rakefile
      drwxr-xr-x 12 kutimiti kutimiti      4096  7月 27 21:28 app
      drwxr-xr-x  2 kutimiti kutimiti      4096  7月 27 21:28 bin
      drwxr-xr-x  5 kutimiti kutimiti      4096  7月 27 21:36 config
      -rw-r--r--  1 kutimiti kutimiti       160  7月 27 21:28 config.ru
      drwxr-xr-x  4 kutimiti kutimiti      4096  7月 27 21:43 db
      -rw-r--r--  1 kutimiti kutimiti 109166380  7月 23 08:52 google-chrome-stable_current_amd64.deb
      drwxr-xr-x  4 kutimiti kutimiti      4096  7月 27 21:28 lib
      drwxr-xr-x  2 kutimiti kutimiti      4096  7月 27 21:35 log
      drwxr-xr-x  2 kutimiti kutimiti      4096  7月 27 21:28 public
      drwxr-xr-x  2 kutimiti kutimiti      4096  7月 27 21:28 storage
      drwxr-xr-x 10 kutimiti kutimiti      4096  7月 27 21:28 test
      drwxr-xr-x  5 kutimiti kutimiti      4096  7月 27 21:35 tmp
      drwxr-xr-x  3 kutimiti kutimiti      4096  7月 27 21:28 vendor
    TEXT
    options = { dot_match: false }
    directory = DirEntry.new(Pathname('../fjord-books_app-2023/'), options)
    assert_equal expected_stats, directory.run_ls_long
  end

  def test_dir_total
    expected_total = 106_680
    options = { dot_match: false }
    directory = DirEntry.new(Pathname('../fjord-books_app-2023/'), options)
    assert_equal expected_total, directory.total
  end

  def test_ls_short
    expected = <<~TEXT.chomp
      autofs          full            kvm             mem             ram11           ram8            stderr          tty15           tty25           tty35           tty45           tty55           tty8            vcsu
      block           fuse            loop-control    net             ram12           ram9            stdin           tty16           tty26           tty36           tty46           tty56           tty9            vcsu1
      bsg             hvc0            loop0           null            ram13           random          stdout          tty17           tty27           tty37           tty47           tty57           ttyS0           vfio
      btrfs-control   hvc1            loop1           nvram           ram14           rtc0            tty             tty18           tty28           tty38           tty48           tty58           ttyS1           vhost-net
      bus             hvc2            loop2           ppp             ram15           sda             tty0            tty19           tty29           tty39           tty49           tty59           ttyS2           vport0p0
      console         hvc3            loop3           ptmx            ram2            sdb             tty1            tty2            tty3            tty4            tty5            tty6            ttyS3           vport0p1
      cpu_dma_latency hvc4            loop4           ptp0            ram3            sdc             tty10           tty20           tty30           tty40           tty50           tty60           urandom         vsock
      cuse            hvc5            loop5           pts             ram4            sg0             tty11           tty21           tty31           tty41           tty51           tty61           vcs             zero
      dri             hvc6            loop6           ram0            ram5            sg1             tty12           tty22           tty32           tty42           tty52           tty62           vcs1
      dxg             hvc7            loop7           ram1            ram6            sg2             tty13           tty23           tty33           tty43           tty53           tty63           vcsa
      fd              kmsg            mapper          ram10           ram7            shm             tty14           tty24           tty34           tty44           tty54           tty7            vcsa1
    TEXT
    options = { dot_match: false }
    directory = DirEntry.new(Pathname('/dev'), options)
    width = 236
    assert_equal expected, directory.run_ls_short(width)
  end
end
