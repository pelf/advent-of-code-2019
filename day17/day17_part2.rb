require_relative './robot2'
require_relative '../misc/machine'

input = File.read("input.txt").chomp

robot = Robot2.new
machine = Machine.new(input, robot)
machine.run
