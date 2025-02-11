require_relative 'addons_linux'
module Dispatcher
  class Dispatch
    include Addons_linux
    
    attr_reader :clipboard

    def initialize
      @clipboard = Clipboard.new
=begin
      @commands = {
        #copy content
        'cpc' => method(:copy_content),
        #paste content
        'cpv' => @clipboard.method(:paste)
      }
=end
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
      p filename
      @clipboard.add_from_file(filename)
      @clipboard.paste
      p @clipboard.memo
    end

    def do_cvc
      @clipboard.paste
    end

    def dispatch(args)
      cmd = args[0..2]
      if cmd == 'cpc'
        do_cpc(args)
        return
      elsif cmd == 'cvc'
        do_cvc
        return
      end
    end
    end
  end
