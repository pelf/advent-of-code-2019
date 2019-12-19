@map = File.readlines("input2a.txt").map do |row|
  row.strip.split('')
end

ROWS = @map.size
COLS = @map.first.size

Key = Struct.new(:row, :col, :key, :distance)

@map.each.with_index do |row,r|
  row.each.with_index do |cell,c|
    if cell == '@'
      @row = r
      @col = c
    end
  end
end

def print_map
  puts
  @map.each do |row|
    puts row.join('')
  end
  puts
end

# crawls maze to find all accessible keys
def find_dependencies(deps, row, col, steps=0)
  v = @map[row][col]
  if letter?(row,col)
    # puts "found key #{v} in #{steps} steps"
    # seen << v #Key.new(row,col,v,steps)
    deps[v] = {}
    deps = deps[v]
    # print_map
  end

  @map[row][col] = ' '
  possible_moves(row, col).each do |r,c|
    find_dependencies(deps, r,c, steps+1)
  end
  @map[row][col] = v
end

def possible_moves(row, col)
  moves = []
  # north
  if row > 0 && free?(row-1, col)
    moves << [row-1,col]
  end
  # south
  if row < ROWS - 1 && free?(row+1, col)
    moves << [row+1,col]
  end
  # west
  if col > 0 && free?(row, col-1)
    moves << [row,col-1]
  end
  # east
  if col < COLS - 1 && free?(row, col+1)
    moves << [row,col+1]
  end

  moves
end

def free?(row, col)
  @map[row][col] == '.' || letter?(row, col)
end

def letter?(row, col)
  @map[row][col] =~ /[a-z]/i
end


dependencies = {}
find_dependencies(dependencies, @row, @col)
require 'pp'
pp dependencies
