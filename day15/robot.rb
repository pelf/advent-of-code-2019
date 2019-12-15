require 'curses'

class Robot
  attr_accessor :squares

  NORTH = 1
  SOUTH = 2
  WEST = 3
  EAST = 4

  WALL = 0
  EMPTY = 1
  GOAL = 2

  CHARS = {
    EMPTY => '.',
    WALL => '█',
    GOAL => 'G'
  }.freeze

  ROWS = 60
  COLS = 60

  SLEEP_ON_INPUT = 0.000

  def initialize
    @squares = Array.new(ROWS) { Array.new(COLS) { 'S' } }
    @row = ROWS / 2
    @col = COLS / 2
    @move = nil

    Curses.init_screen
    Curses.curs_set 0
    Curses.noecho
  end

  def read
    sleep SLEEP_ON_INPUT
    @move = rand(4) + 1
  end

  def write(val)
    case val
    when WALL
      moved = false
    else
      moved = true
    end

    # clear current robot position
    Curses.setpos(@row, @col)
    Curses.addstr(@squares[@row][@col])

    case @move
    when NORTH
      @squares[@row-1][@col] = val
      Curses.setpos(@row-1, @col)
      Curses.addstr(CHARS[val])
      @row -= 1 if moved
    when SOUTH
      @squares[@row+1][@col] = val
      Curses.setpos(@row+1, @col)
      Curses.addstr(CHARS[val])
      @row += 1 if moved
    when WEST
      @squares[@row][@col-1] = val
      Curses.setpos(@row, @col-1)
      Curses.addstr(CHARS[val])
      @col -= 1 if moved
    when EAST
      @squares[@row][@col+1] = val
      Curses.setpos(@row, @col+1)
      Curses.addstr(CHARS[val])
      @col += 1 if moved
    end

    # draw robot
    Curses.setpos(@row, @col)
    Curses.addstr('R')

    Curses.refresh
  end

  def halt
    sleep 10
    Curses.close_screen
  end
end
