require_relative 'addons_linux'
module Dispatcher
  class Dispatch
    include Addons_linux

    def initialize
      @clipboard = Clipboard.new
      @commands = {
        #copy content
        'cpc' => method(:copy_content),
        #paste content
        'cpv' => @clipboard.method(:paste)
      }
    end

    def copy_content(filename)
      @clipboard.add_from_file(filename)
    end

    def dispatch(args)
      @commands.key?(args[0]) ? @commands[args[0]].call(args[1]) : return
    end
  end
end
