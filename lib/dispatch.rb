require_relative 'addons_linux'
require_relative 'shell_linux'
module Dispatcher
  class Dispatch
    include Addons_linux
    
    attr_reader :clipboard

    def initialize
      @clipboard = Clipboard.new
    end

    def copy_content(filename)
      @clipboard.add_from_file(filename)
    end

    def hint
      puts "Usage: cpc <filename>"
    end

    def do_cpc(args)
      #filename
      filename = args[4..-1]
      @clipboard.add_from_file(filename)
    end

    def do_cvc
      print @clipboard.paste
    end

    def dispatch(args)
      cmd = args[0..2]
      if cmd == 'cpc'
        do_cpc(args)
        return
      elsif cmd == 'cvc'
        do_cvc
        return
      elsif cmd == 'ben'
        ShellLinux::BenchmarkShell.new.shell_lin
      end
    end
    end
  end
