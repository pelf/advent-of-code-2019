require_relative './cpu'
require_relative '../misc/machine'

class Master
  def initialize(input)
    @memory = []
    @machines = []

    50.times do |n|
      @memory[n] = []
      cpu = Cpu.new(n, self)
      @machines[n] = Machine.new(input, cpu)
    end
  end

  def run
    loop do
      @machines.each do |machine|
        machine.step
      end
    end
  end

  def read(address)
    @memory[address].empty? ? -1 : @memory[address].shift
  end

  def write(address, x, y)
    if address == 255
      puts y
      exit
    else
      @memory[address] << x
      @memory[address] << y
    end
  end
end

input = File.read("input.txt").chomp
Master.new(input).run
