class Robot
  MAP_SIZE = 100
  NEW_LINE = 10
  INSTRUCTIONS = [
    "north",
    "south",
    "east",
    "west",
    # TODO
  ].freeze

  def initialize
    @row = 30
    @col = 30
    @cur_inst = nil
    @map = Array.new(MAP_SIZE) { Array.new(MAP_SIZE) { ' ' }}
    @last_move = nil
  end

  def read
    # pick new instruction
    unless @cur_inst
      @cur_inst = gets.chomp.chars
    end

    # have we not finished the current instruction?
    if @cur_inst.any?
      chr = @cur_inst.shift
      chr.ord
    else # update position and terminate with new line
      @cur_inst = nil
      # move!
      # print_map
      NEW_LINE
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

  # def move!
  #   @map[@row][@col] = '.'

  #   case @last_move
  #   when 0 # north
  #     @row -= 1
  #   when 1 # south
  #     @row += 1
  #   when 2 # east
  #     @col += 1
  #   when 3 # west
  #     @col -= 1
  #   end

  #   @map[@row][@col] = 'R'
  # end

  def print_map
    puts `clear`
    @map.each.with_index do |row, r|
      row.each.with_index do |sq, c|
        print sq
      end
      puts ''
    end
  end
end
