#!/usr/bin/env ruby

require 'open3'
require 'irb'

module Colorize

  COLOURS = {
    red: "\e[31m",
    green: "\e[32m",
    yellow: "\e[33m",
    blue: "\e[34m",
    lblue: "\e[0;94m",
    teal: "\e[0;96m",
    reset: "\e[0m"
  }

  def colorize(colour, input)
    output = "#{COLOURS[colour]}#{input}#{COLOURS[:reset]}"
    output.strip
  end
end

class Param
	
  def self.sanitize(prompt)
    prompt.insert(0, "'")
    prompt.insert(-1, "'")
    prompt
  end

  def self.cd_handle(arg)
    #change directory
#    arg = cd_helper(args)
    if arg.length == 2
        Dir.chdir(arg[1])
        puts "Changed dir to #{Dir.pwd}"
    else
        puts "Usage: cd <dir>"
    end
    rescue Errno::ENOENT
      p "Directory not found: #{arg[1]}"
    rescue Errno::EACCES
      p "Permission denied: #{arg[1]}"
  end

  def self.interactive(args)
    if args[0] == "irb"
      puts "Entering irb"
      IRB.start(__FILE__)
    end
    rescue IRB::Abort => e
      puts "Exiting irb"
    end

  def self.chdir?(arg)
    arg[0] == "cd"
  end

  def self.check(array)
    if chdir?(array)
      cd_handle(array)
      return
    end
    begin
      stdout, stderr, status = Open3.capture3(*array.map(&:to_s).reject(&:empty?))
    rescue Errno::ENOENT
      p "Failed. Invalid command?"
	    return
    rescue ArgumentError
      p "Invalid arguments. Something went wrong, send patches!"
      return
    else
        interactive(array)
        if stdout == ""
          command = array.map(&:to_s)
            sanitize(command)
            sanitized = "bash -c " << command.join
            system(sanitized)
        end
      end
    puts status.success? ? stdout : "Failed: #{stderr}"
  end
end

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

if __FILE__ == $0
  Shella.new.shell_logic
end

