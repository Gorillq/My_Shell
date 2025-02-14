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
