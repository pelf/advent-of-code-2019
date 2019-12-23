require_relative './cpu'
require_relative '../misc/machine'

class Master
  def initialize(input)
    @memory = []
    @machines = []
    @done = false

    50.times do |n|
      @memory[n] = []
      cpu = Cpu.new(n, self)
      @machines[n] = Machine.new(input, cpu)
    end
  end

  def run
    i = 0
    loop do
      @machines[i].step
      i = (i + 1) % 50
    end
  end

  def read(address)
    @memory[address].empty? ? -1 : @memory[address].shift
  end

  def write(address, val)
    if address == 255
      if @done
        puts val
        exit
      end
      @done = true
    else
      @memory[address] << val
    end
  end
end

input = File.read("input.txt").chomp
Master.new(input).run
