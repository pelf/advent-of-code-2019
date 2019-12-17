# Solution found by hand :|
# A,B,A,C,B,C,B,A,C,B
# L,10,L,6,R,10
# R,6,R,8,R,8,L,6,R,8
# L,10,R,8,R,8,L,10

class Robot2
  attr_accessor :squares, :intersections

  NEW_LINE = 10
  SCAFFOLD = 35

  SLEEP_ON_INPUT = 0.000

  def initialize
    @squares = []
    @row = 0

    @inputs = [
      ["A","B","A","C","B","C","B","A","C","B"],
      ["L","10","L","6","R","10"],
      ["R","6","R","8","R","8","L","6","R","8"],
      ["L","10","R","8","R","8","L","10"],
      ["n"]
    ]
  end

  def read
    cmd = @inputs.shift
    cmd = (cmd.map(&:ord) + [NEW_LINE]).join("")
    puts "reading #{cmd}"
    cmd
  end

  def write(val)
    if val == NEW_LINE
      @row += 1
    else
      squares[@row] ||= []
      squares[@row] << val
    end

    # print
  end

  def halt
    exit
  end

  private

  def find_intersections
    @intersections = []

    squares.each.with_index do |row, r|
      next if r == 0 || r == squares.size - 1
      row.each.with_index do |cell, c|
        next if c == 0 || c == row.size - 1
        if cell == SCAFFOLD && squares[r-1][c] == SCAFFOLD && squares[r+1][c] == SCAFFOLD  && squares[r][c-1] == SCAFFOLD  && squares[r][c+1] == SCAFFOLD
          @intersections << [r, c]
        end
      end
    end
  end

  def print
    puts `clear`
    squares.each do |row|
      puts row.map(&:chr).join('')
    end
  end
end
