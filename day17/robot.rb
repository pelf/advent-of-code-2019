class Robot
  attr_accessor :squares, :intersections

  NEW_LINE = 10
  SCAFFOLD = 35

  def initialize
    @squares = []
    @row = 0
  end

  def read
    raise "read!"
  end

  def write(val)
    if val == NEW_LINE
      @row += 1
    else
      squares[@row] ||= []
      squares[@row] << val
    end
  end

  def halt
    find_intersections
    p intersections.map { |r,c| r * c }.reduce(:+)
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
