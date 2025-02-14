module Addons_linux
  class Clipboard
    attr_reader :memo
    def initialize
      @memo = []
    end

    def add(text)
      @memo = [text]
    end

    def add_from_file(filename)
      begin
        content = File.read(filename)
        add(content)
      rescue Errno::ENOENT
        puts "File #{filename} not found"
      rescue ArgumentError
        puts "Usage: cpc <filename>"
      rescue => e
        puts "Error reading file #{e.message}"
      end
    end
    
    def paste
      print @memo.first
    end
  end
end


