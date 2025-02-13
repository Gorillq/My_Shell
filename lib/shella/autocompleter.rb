require 'irb/completion'
require 'readline'

class Autocompleter
  
  def initialize
      @command = ["mkdir", "rmdir", "touch", "echo", "exit", "help", "grep", "sort", "uniq"]
      @files = Dir.entries('.').reject { |f| f == '.' || f == '..' }
      @completion_proc = proc { |s| (@command + @files).select {|input| input.start_with?(s) } }
  end
  
  def completion_proc
    @completion_proc
  end
end 
