require_relative '../misc/machine'

class Drone
  def initialize(input,row,col)
    @input = input
    @state = 0
    @row = row
    @col = col
  end

  def run
    @machine = Machine.new(@input, self)
    @machine.run
    @val
  end

  def read
    if @state == 0
      val = @col
    else
      val = @row
    end
    @state += 1
    val
  end

  def write(val)
    @val = val
  end

  def halt
  end
end
