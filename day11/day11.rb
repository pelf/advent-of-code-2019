require_relative './robot'
require_relative './machine'

input = File.read("input.txt").chomp

robot = Robot.new
machine = Machine.new(input, robot)
machine.run
