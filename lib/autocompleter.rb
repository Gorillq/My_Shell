require 'irb/completion'
require 'readline'

class Autocompleter
  def initialize
    @command = ["mkdir", "rmdir", "touch", "echo", "exit", "help", "grep", "sort", "uniq", "cat", "cpc", "cvc", "ben"]
  end

  def completion_proc(current_dir = '.')
    files = Dir.entries(current_dir).reject { |f| f == '.' || f == '..' }
    proc { |s| (@command + files).select {|input| input.start_with?(s) } }
  end
end
