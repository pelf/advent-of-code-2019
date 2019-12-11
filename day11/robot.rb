class Robot
  attr_accessor :row, :col, :dir, :squares, :state, :painted

  SIZE = 100
  BLACK = 0
  WHITE = 0

  STATES = [:paint, :move]

  def initialize
    @row = SIZE / 2
    @col = SIZE / 2
    @dir = 0
    @squares = Array.new(SIZE) { Array.new(SIZE) { 0 } }
    # part 2 - initial square is white
    @squares[@row][@col] = 1
    @state = 0
    @painted = {}
  end

  def read
    puts "reading #{row},#{col}"
    squares[row][col]
  end

  def write(val)
    if current_state == :paint
      puts "painting #{row},#{col} -> #{val}"
      squares[row][col] = val
      self.painted[[row,col]] = true
    else # move
      if val == 0
        puts "rotating left"
        self.dir -= 90
      else
        puts "rotating right"
        self.dir += 90
      end
      move(1)
    end

    self.state += 1
  end

  def halt
    puts "done"
    puts "painted #{painted.size} panels at least once"

    self.squares.each do |row|
      puts row.map { |sq| sq == 0 ? ' ' : '█'}.join('')
    end
  end

  private

  def current_state
    STATES[state%STATES.size]
  end

  def move(dist)
    case dir % 360
    when 0
      self.row -= dist
    when 90
      self.col += dist
    when 180
      self.row += dist
    when 270
      self.col -= dist
    else
      raise "oops!"
    end
    puts "moved to #{row},#{col}"
  end
end
