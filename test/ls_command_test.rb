# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../07.ls_object/ls_command'

class LsCommandTest < Minitest::Test
  def test_run_files
    expected = <<~TEXT
      01.fizzbuzz/fizzbuzz.rb      03.bowling/bowling.rb        07.ls_object/dir_entry.rb    07.ls_object/main.rb
      02.calendar/calendar.rb      04.ls/ls_command.rb          07.ls_object/entries_list.rb 07.ls_object/main.rb
    TEXT
    options = { dot_match: false }

    path1 = Pathname('02.calendar/calendar.rb')
    path2 = Pathname('01.fizzbuzz/fizzbuzz.rb')
    path3 = Pathname('07.ls_object/ls_long.rb')
    path4 = Pathname('03.bowling/bowling.rb')
    path5 = Pathname('04.ls/ls_command.rb')
    path6 = Pathname('07.ls_object/dir_entry.rb')
    path7 = Pathname('07.ls_object/ls_long.rb')
    path8 = Pathname('07.ls_object/ls_long.rb')
    path9 = Pathname('07.ls_object/main.rb')
    path10 = Pathname('07.ls_object/entries_list.rb')
    path11 = Pathname('07.ls_object/main.rb')
    paths = [path1, path2, path3, path4, path5, path6, path7, path8, path9, path10, path11]
    command = LsCommand.new(paths, options)
    assert_output(expected) { command.run }
  end

  def test_run_directories_if_dotmatch_is_true
    expected = <<~TEXT
      .               hvc3            mem             ram3            stdin           tty21           tty37           tty52           ttyS1
      autofs          hvc4            net             ram4            stdout          tty22           tty38           tty53           ttyS2
      block           hvc5            null            ram5            tty             tty23           tty39           tty54           ttyS3
      bsg             hvc6            nvram           ram6            tty0            tty24           tty4            tty55           urandom
      btrfs-control   hvc7            ppp             ram7            tty1            tty25           tty40           tty56           vcs
      bus             kmsg            ptmx            ram8            tty10           tty26           tty41           tty57           vcs1
      console         kvm             ptp0            ram9            tty11           tty27           tty42           tty58           vcsa
      cpu_dma_latency loop-control    pts             random          tty12           tty28           tty43           tty59           vcsa1
      cuse            loop0           ram0            rtc0            tty13           tty29           tty44           tty6            vcsu
      dri             loop1           ram1            sda             tty14           tty3            tty45           tty60           vcsu1
      dxg             loop2           ram10           sdb             tty15           tty30           tty46           tty61           vfio
      fd              loop3           ram11           sdc             tty16           tty31           tty47           tty62           vhost-net
      full            loop4           ram12           sg0             tty17           tty32           tty48           tty63           vport0p0
      fuse            loop5           ram13           sg1             tty18           tty33           tty49           tty7            vport0p1
      hvc0            loop6           ram14           sg2             tty19           tty34           tty5            tty8            vsock
      hvc1            loop7           ram15           shm             tty2            tty35           tty50           tty9            zero
      hvc2            mapper          ram2            stderr          tty20           tty36           tty51           ttyS0
    TEXT
    options = { dot_match: true }

    path = Pathname('/dev')
    paths = [path]
    command = LsCommand.new(paths, options)
    assert_output(expected) { command.run }
  end

  def test_run_directories_if_dotmatch_is_false
    expected = <<~TEXT
      autofs          hvc4            net             ram4            stdout          tty22           tty38           tty53           ttyS2
      block           hvc5            null            ram5            tty             tty23           tty39           tty54           ttyS3
      bsg             hvc6            nvram           ram6            tty0            tty24           tty4            tty55           urandom
      btrfs-control   hvc7            ppp             ram7            tty1            tty25           tty40           tty56           vcs
      bus             kmsg            ptmx            ram8            tty10           tty26           tty41           tty57           vcs1
      console         kvm             ptp0            ram9            tty11           tty27           tty42           tty58           vcsa
      cpu_dma_latency loop-control    pts             random          tty12           tty28           tty43           tty59           vcsa1
      cuse            loop0           ram0            rtc0            tty13           tty29           tty44           tty6            vcsu
      dri             loop1           ram1            sda             tty14           tty3            tty45           tty60           vcsu1
      dxg             loop2           ram10           sdb             tty15           tty30           tty46           tty61           vfio
      fd              loop3           ram11           sdc             tty16           tty31           tty47           tty62           vhost-net
      full            loop4           ram12           sg0             tty17           tty32           tty48           tty63           vport0p0
      fuse            loop5           ram13           sg1             tty18           tty33           tty49           tty7            vport0p1
      hvc0            loop6           ram14           sg2             tty19           tty34           tty5            tty8            vsock
      hvc1            loop7           ram15           shm             tty2            tty35           tty50           tty9            zero
      hvc2            mapper          ram2            stderr          tty20           tty36           tty51           ttyS0
      hvc3            mem             ram3            stdin           tty21           tty37           tty52           ttyS1
    TEXT
    options = { dot_match: false }

    path = Pathname('/dev')
    paths = [path]
    command = LsCommand.new(paths, options)
    assert_output(expected) { command.run }
  end

  def test_run_files_long
    expected = <<~TEXT
      -rw-r--r-- 1 kutimiti kutimiti 2698  7月 27 21:36 ../fjord-books_app-2023/Gemfile
      -rw-r--r-- 1 kutimiti kutimiti  258  7月 27 21:28 ../fjord-books_app-2023/Rakefile
    TEXT
    options = { long_format: true, dot_match: false }

    paths = [Pathname('../fjord-books_app-2023/Gemfile'), Pathname('../fjord-books_app-2023/Rakefile')]
    command = LsCommand.new(paths, options)
    assert_output(expected) { command.run }
  end

  def test_run_directories_long
    expected = <<~TEXT
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
    options = { long_format: true, dot_match: false }

    path = Pathname('../fjord-books_app-2023/')
    paths = [path]
    command = LsCommand.new(paths, options)
    assert_output(expected) { command.run }
  end

  def test_run_files_directories_long
    expected = <<~TEXT
      -rw-r--r-- 1 kutimiti kutimiti 2698  7月 27 21:36 ../fjord-books_app-2023/Gemfile

      ../fjord-books_app-2023:
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
    options = { long_format: true, dot_match: false }

    path = Pathname('../fjord-books_app-2023')
    path2 = Pathname('../fjord-books_app-2023/Gemfile')
    paths = [path, path2]
    command = LsCommand.new(paths, options)
    assert_output(expected) { command.run }
  end
end
