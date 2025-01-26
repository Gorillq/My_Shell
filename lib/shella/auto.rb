module Auto
  class Thrd
    def listen
      STDIN.read_nonblock(1)
    end
  end
end
