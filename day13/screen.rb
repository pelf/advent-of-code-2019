require 'curses'

class Screen
  attr_accessor :output, :ball_x, :paddle, :score

  EMPTY = 0
  WALL = 1
  BLOCK = 2
  PADDLE = 3
  BALL = 4

  CHARS = {
    EMPTY => ' ',
    WALL => '█',
    BLOCK => '░',
    PADDLE => '_',
    BALL => 'o'
  }.freeze

  def initialize
    @output = []
    @ball_x = 18
    @paddle = 0
    @score = 0
    Curses.init_screen
    Curses.curs_set 0 # invisible cursor
    Curses.noecho
  end

  def read
    # sleep 0.005
    ball_x <=> paddle
  end

  def write(val)
    self.output << val
    if output.size % 3 == 0
      x = output[-3]
      y = output[-2]
      if x == -1 && y == 0
        Curses.setpos(10, 42)
        Curses.addstr("SCORE: #{val.to_s}")
        self.score = val
      else
        Curses.setpos(y, x)
        Curses.addstr(CHARS[val])
        if val == BALL
          self.ball_x = x
        elsif val == PADDLE
          self.paddle = x
        end
      end
      Curses.refresh
    end
  end

  def halt
    sleep 10
    Curses.close_screen
  end
end
