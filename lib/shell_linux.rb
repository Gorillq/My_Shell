 require "irb"
 require "readline"
 require "open3"
 require 'benchmark'
 require_relative 'colorize'
 require_relative 'dispatch'
 require_relative 'autocompleter'
 
module ShellLinux
 class Shell
   include Colorize
   include Dispatcher
 
   def initialize
     @dispatcher = Dispatch.new
     @autocomplete = Autocompleter.new
     Readline.completion_proc = @autocomplete.completion_proc
   end
 
   def interactive?(args)
     args[0] == "irb"
   end
 
   def interactive()
     puts "Entering irb"
     IRB.start(__FILE__)
   end
 
   def chdir?(args)
     args[0] == "cd"
   end
 
   def cd_handle(args)
     if args.length == 2
       Dir.chdir(args[1])
       puts "Changed dir to #{Dir.pwd}"
     else
       puts "Usage: cd <dir>"
     end
   rescue Errno::ENOENT
     puts "Directory not found: #{args[1]}"
   rescue Errno::EACCES
     puts "Permission denied: #{args[1]}"
   end
 
   private def userhost
     user = `whoami`.strip
     host = `uname -n`.strip
     username = colorize(:teal, user)
     hostname = colorize(:teal, host)
     at = colorize(:red, "@")
     dollar = colorize(:red, "$:>")
     open = colorize(:green, "[")
     close = colorize(:green, "]")
     result = open << username << at << hostname << close << dollar
   end
 
   private def prompt_method(input)
     input.split.map(&:to_s)
   end
 
   private def terminate
     puts "Bye!"
     exit
   end
 
   def terminate?(args)
     args[0] == 'exit'
   end
 
   def set_home
     Dir.chdir()
   end
 
   def get_user_input(user)
     Readline.readline(user, true)
   end
 
   private def bash_method(args)
     command = "bash -c \"" + args.join(" ").gsub('"', '\"') + "\""
     system(command)
   end
 
   def check(args)
     begin
       stdout, stderr, status = Open3.capture3(*args)
       if stdout == "" && !args.include?("bash")
         bash_method(args)
       elsif status.success?
         puts stdout
       else
         puts "Failed #{stderr}"
       end
     rescue Errno::ENOENT
       return
     rescue ArgumentError
       puts "Something went wrong. Empty command?"
     end
   end
 
  def shell_lin
    trap 'SIGINT' do
      puts "Interrupted. Exiting..."
      print "\e[2J\e[H" # clear the screen
      print "\e[?25h"  # show the cursor
      print "\e[0m"
      terminate
    end
    set_home
    display = userhost
    loop do
      tmp = get_user_input(display)
      Readline::HISTORY.push(tmp) if !tmp.nil? && !tmp.empty?
      command = prompt_method(tmp)
      @dispatcher.dispatch(tmp)
      execute_command(command)
      break if terminate?(command)
    end
  end

  def execute_command(command)
    case
    when chdir?(command)
      cd_handle(command)
    when interactive?(command)
      interactive
    when terminate?(command)
      terminate
    else
      check(command)
    end
  end
 end

  class BenchmarkShell < Shell

	def initialize
	  super
	end

	def shell_lin
	  super
	end

    def execute_command(command)
      start_time = Time.now
      super(command)
      end_time = Time.now
      elapsed_time = end_time - start_time
      puts "Benchmark for #{command.join(' ')}: #{elapsed_time} seconds"
    end
  end
end
    
    
