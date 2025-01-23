#!/usr/bin/env ruby

require 'open3'

class Param
	
  def self.sanitize(prompt)
    prompt.insert(0, "'")
    prompt.insert(-1, "'")
    prompt
  end

  def self.check(array)
    stdout, stderr, status = Open3.capture3(*array.map(&:to_s))
    if stdout == ""
      command = array.map(&:to_s)
      sanitize(command)
      sanitized = "bash -c " << command.join
      system(sanitized)
    end
    puts status.success? ? stdout : "Failed: #{stderr}"
  end

end

class Shella < Param

  def initialize(*args)
    super
  end

  def userhost
    username = `whoami`
    hostname = `uname -n`
    return username, hostname
  end

  def print_user(user, host)
    print "[" << user.strip << "@" << host.strip << "]" << "$ "
  end

  def prompt_methods(input)
    input.split.map(&:to_s)
  end
=begin
  def prompt_methods(input)
    input.split.map { |arg| Shellwords.escape(arg) }
  end
=end
  def shell_logic
    loop do
      get_user, get_host = userhost
      print_user(get_user, get_host)
      tmp = gets.chomp
      args = prompt_methods(tmp)
      Param.check(args)
    end
  end
end

if __FILE__ == $0
  Shella.new.shell_logic
end

