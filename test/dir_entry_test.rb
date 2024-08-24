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
      autofs         cpu_dma_latency  fuse  hvc5          loop0  loop6   nvram  ram1   ram15  ram7    sdb  stderr  tty10  tty16  tty21  tty27  tty32  tty38  tty43  tty49  tty54  tty6   tty8   urandom  vcsu1      zero
      block          cuse             hvc0  hvc6          loop1  loop7   ppp    ram10  ram2   ram8    sdc  stdin   tty11  tty17  tty22  tty28  tty33  tty39  tty44  tty5   tty55  tty60  tty9   vcs      vfio
      bsg            dri              hvc1  hvc7          loop2  mapper  ptmx   ram11  ram3   ram9    sg0  stdout  tty12  tty18  tty23  tty29  tty34  tty4   tty45  tty50  tty56  tty61  ttyS0  vcs1     vhost-net
      btrfs-control  dxg              hvc2  kmsg          loop3  mem     ptp0   ram12  ram4   random  sg1  tty     tty13  tty19  tty24  tty3   tty35  tty40  tty46  tty51  tty57  tty62  ttyS1  vcsa     vport0p0
      bus            fd               hvc3  kvm           loop4  net     pts    ram13  ram5   rtc0    sg2  tty0    tty14  tty2   tty25  tty30  tty36  tty41  tty47  tty52  tty58  tty63  ttyS2  vcsa1    vport0p1
      console        full             hvc4  loop-control  loop5  null    ram0   ram14  ram6   sda     shm  tty1    tty15  tty20  tty26  tty31  tty37  tty42  tty48  tty53  tty59  tty7   ttyS3  vcsu     vsock
    TEXT
    options = { dot_match: false }
    directory = DirEntry.new(Pathname('/dev'), options)
    width = 236
    assert_equal expected, directory.run_ls_short(width)
  end
end
