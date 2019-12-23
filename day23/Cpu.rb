class Cpu
  def initialize(address, memory)
    @address = address
    @memory = memory
    @state = -1
    @buffer = []
  end

  def read
    if @state == -1
      @state = 0
      @address
    else
      @memory.read(@address)
    end
  end

  def write(val)
    @buffer << val
    @state += 1

    # message done?
    if @state == 3
      # pass it on
      @memory.write(*@buffer)
      # reset
      @state = 0
      @buffer = []
    end
  end

  def halt
    # exit
  end
end
