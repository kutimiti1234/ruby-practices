# frozen_string_literal: true

class Entry
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def run_ls_short
    raise NotImplementedError, 'This method should be overridden by subclasses'
  end

  def run_ls_long
    raise NotImplementedError, 'This method should be overridden by subclasses'
  end
end
