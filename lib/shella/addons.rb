module Addons
	class Content
		def initialize
      @memo = []
		end
		def fax(input)
			File.open(input, "r") do |file|
				file.each_line do |line|
					@memo << line
				end
			end
		end
    def putfax
      memo = @memo
      IO.popen(memo, "w") {|pipe| pipe.puts memo}
    end
	end
end
				
