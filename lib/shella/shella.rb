require_relative 'colorize'
require_relative 'param'

class Shella < Param
  include Colorize

  def initialize(*args)
    super
  end

  def userhost
    username = `whoami`.strip
    hostname = `uname -n`.strip
    return username, hostname
  end

  def print_user(user, host)
    at = colorize(:red, "@")
    dollar = colorize(:red, "$: ")
    o_bracket = colorize(:green, "[")
    b_bracket = colorize(:green, "]")
    print o_bracket << user << at << host << b_bracket << dollar
  end

  def prompt_methods(input)
    input.split.map(&:to_s)
   # input.strip.gsub(/\s+/, ' ').split.map(&:to_s).reject(&:empty?)
  end
  
  def terminate
    puts "Bye!"
    Kernel.exit!(0)
  end
  
  def isexit?(arg)
    arg == "exit"
  end

  def set_home
    Dir.chdir()
  end

  def ends(arg)
    isexit?(arg) ? terminate : return
  end

  def shell_logic
    set_home
    loop do
      get_user, get_host = userhost
      user = colorize(:lblue, get_user)
      host = colorize(:teal, get_host)
      print_user(user, host)
      tmp = gets.chomp
      ends(tmp)
      args = prompt_methods(tmp)
      Param.check(args)
    end
  end
end
