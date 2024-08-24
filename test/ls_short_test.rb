# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require_relative '../07.ls_object/ls_short'

class LsShortTest < Minitest::Test
  def test_run_files
    expected = <<~TEXT
      01.fizzbuzz/fizzbuzz.rb   03.bowling/bowling.rb     07.ls_object/dir_entry.rb 07.ls_object/ls_long.rb   07.ls_object/ls_long.rb   07.ls_object/main.rb
      02.calendar/calendar.rb   04.ls/ls_command.rb       07.ls_object/entry.rb     07.ls_object/ls_long.rb   07.ls_object/main.rb
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
    path10 = Pathname('07.ls_object/entry.rb')
    path11 = Pathname('07.ls_object/main.rb')
    paths = [path1, path2, path3, path4, path5, path6, path7, path8, path9, path10, path11]
    width = 236
    command = LsShort.new(paths, options, width)
    assert_output(expected) { command.run }
  end

  def test_run_directories_if_dotmatch_is_true
    expected = <<~TEXT
      .               fd              kmsg            mapper          ram10           ram7            shm             tty14           tty24           tty34           tty44           tty54           tty7            vcsa1
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
    TEXT
    options = { dot_match: true }

    path = Pathname('/dev')
    paths = [path]
    width = 236
    command = LsShort.new(paths, options, width)
    assert_output(expected) { command.run }
  end

  def test_run_directories_if_dotmatch_is_false
    expected = <<~TEXT
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

    path = Pathname('/dev')
    paths = [path]
    width = 236
    command = LsShort.new(paths, options, width)
    assert_output(expected) { command.run }
  end
end
