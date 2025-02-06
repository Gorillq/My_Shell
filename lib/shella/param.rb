require 'open3'
require 'irb'
require_relative 'addons'

class Param
  
  def initialize
    @addons = Addons::Content.new
  end

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
      puts "Directory not found: #{arg[1]}"
    rescue Errno::EACCES
      puts "Permission denied: #{arg[1]}"
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

  def self.addon?(arg)
    arg[0] == "cpc"
  end

  def self.check(array)
    if chdir?(array)
      cd_handle(array)
      return
    end
    if addon?(array)
      @addons.fax(array[1])
      @addons.putfax
    end
    begin
      stdout, stderr, status = Open3.capture3(*array.map(&:to_s).reject(&:empty?))
    rescue Errno::ENOENT
      puts "Failed. Invalid command?"
    rescue ArgumentError
      p "Invalid arguments. Something went wrong, send patches!"
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
