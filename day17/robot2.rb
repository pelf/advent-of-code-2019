class Robot2
  attr_accessor :squares, :intersections

  NEW_LINE = 10
  SCAFFOLD = 35

  def initialize
    @squares = []
    @row = 0

    # Solution found by hand. Shameful, I know.
    @inputs = [
      %w[A , B , A , C , B , C , B , A , C , B],
      %w[L , 1 0 , L , 6 , R , 1 0],
      %w[R , 6 , R , 8 , R , 8 , L , 6 , R , 8],
      %w[L , 1 0 , R , 8 , R , 8 , L , 1 0],
      %w[n]
    ]
  end

  def read
    @row = 0
    @squares = []

    if (@inputs.first.empty?)
      @inputs.shift
      NEW_LINE
    else
      @inputs.first.shift.ord
    end
  end

  def write(val)
    if val > 255
      puts val
    elsif val == NEW_LINE
      @row += 1
    else
      squares[@row] ||= []
      squares[@row] << val
    end

    print
  end

  def halt
    exit
  end

  private

  def print
    puts `clear`
    squares.each do |row|
      next unless row
      puts row.map(&:chr).join('')
    end
  end
end
