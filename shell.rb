 #!/usr/bin/env ruby

require 'open3'
require 'rainbow'

class Shella
  def scaner
    input = gets.chomp
    input
  end 
  def sanitize(prompt)
    prompt.insert(0, "'")
    prompt.insert(-1, "'")
    prompt
  end
  def userhost
    username = `whoami`
    hostname = `uname -n`
    return username, hostname
  end
  def print_user(user, host)
    print "[" << user.strip << "@" << host.strip << "]" << "$ "
  end
  def check(prompt)
    stdout, stderr, status = Open3.capture3(prompt)
    puts status.success? ? stdout : "Failed"
  end
  def shell_logic
    loop do
      get_user, get_host = userhost
      print_user(get_user, get_host)
      tmp = scaner
      input = sanitize(tmp)
      check(input)
    end
  end
end

if __FILE__ == $0
  Shella.new.shell_logic
end

