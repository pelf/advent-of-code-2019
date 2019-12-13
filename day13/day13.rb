require_relative './screen'
require_relative './machine'

input = File.read("input.txt").chomp

screen = Screen.new
machine = Machine.new(input, screen)
machine.run
