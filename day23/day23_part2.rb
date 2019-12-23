require_relative './cpu'
require_relative '../misc/machine'

class Master
  def initialize(input)
    @memory = []
    @machines = []
    @empty_reads = []
    @last_nat_y = nil

    50.times do |n|
      @memory[n] = []
      @empty_reads[n] = 0
      cpu = Cpu.new(n, self)
      @machines[n] = Machine.new(input, cpu)
    end
  end

  def run
    loop do
      @machines.each do |machine|
        machine.step
      end

      if idle?
        if @nat[1] == @last_nat_y
          puts @last_nat_y
          exit
        end
        print "."
        @memory[0] << @nat[0]
        @memory[0] << @nat[1]
        @last_nat_y = @nat[1]
      end
    end
  end

  def read(address)
    if @memory[address].empty?
      @empty_reads[address] += 1
      -1
    else
      @empty_reads[address] = 0
      @memory[address].shift
    end
  end

  def write(address, x, y)
    if address == 255
      @nat = [x,y]
    else
      @memory[address] << x
      @memory[address] << y
    end
  end

  private

  def idle?
    # not idle if there's stuff in the memory queues
    return false if @memory.any? { |m| m.any? }
    # idle if every cpu has failed to read a value more than once
    @empty_reads.all? { |r| r > 1 }
  end
end

input = File.read("input.txt").chomp
Master.new(input).run
