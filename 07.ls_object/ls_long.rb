# frozen_string_literal: true

class LsLong
  def run(entries)
    header = ["合計 #{entries.total.to_i}"]
    max_sizes = entries.find_max_sizes
    body = entries.file_entries.map do |file|
      "#{file.mode} "\
      "#{file.nlink.rjust(max_sizes[:nlink])} " \
      "#{file.user.ljust(max_sizes[:user])} " \
      "#{file.group.ljust(max_sizes[:group])} " \
      "#{file.size.rjust(max_sizes[:size])}  " \
      "#{file.time.rjust(max_sizes[:time])} " \
      "#{file.name}" \
    end.join("\n")
    [header, body].join("\n")
  end
end
