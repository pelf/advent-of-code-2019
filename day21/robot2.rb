class Robot2
  attr_accessor :squares

  NEW_LINE = 10

  def initialize
    @row = 0
    # If there is a gap and can land safely
    # AND either take another step or jump again: jump
    @inputs = [
      "NOT A T",
      "NOT B J",
      "OR T J",
      "NOT C T",
      "OR T J",
      "AND D J",
      "NOT H T",
      "NOT T T",
      "OR E T",
      "AND T J",
      "RUN"
    ].map { |l| l.split("") }
  end

  def read
    @row = 0

    if (@inputs.first.empty?)
      @inputs.shift
      NEW_LINE
    else
      @inputs.first.shift.ord
    end
  end

  def write(val)
    if val <= 255
      print val.chr
    else
      puts val
    end
  end

  def halt
    exit
  end

  private

  def print_squares
    puts `clear`
    squares.each do |row|
      next unless row
      puts row.map(&:chr).join('')
    end
  end
end
