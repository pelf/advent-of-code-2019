@map = File.readlines("input.txt").map do |row|
  row.strip.split('')
end

ROWS = @map.size
COLS = @map.first.size

Key = Struct.new(:row, :col, :key, :distance)

@keys = []
@row = 0
@col = 0

@cache = {}

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
def possible_keys(row, col, steps=0)
  # print_map
  v = @map[row][col]
  if key?(row,col)
    # puts "found key #{v} in #{steps} steps"
    return [Key.new(row,col,v,steps)]
  end

  @map[row][col] = ' '
  keys = []
  possible_moves(row, col).each do |r,c|
    keys += possible_keys(r,c, steps+1)
  end
  @map[row][col] = v
  keys
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
  @map[row][col] == '.' || key?(row, col) || @keys.include?(@map[row][col].downcase)
end

def key?(row, col)
  @map[row][col] =~ /[a-z]/
end

def keys_to_pick(row,col)
  # check cache
  cache_key = "#{row},#{col}" + @keys.sort.join("")
  return @cache[cache_key] if @cache[cache_key]

  next_key_distance = {}

  possible_keys(row, col).each do |key|
    if !next_key_distance[key.key] || next_key_distance[key.key].distance > key.distance
      next_key_distance[key.key] = key
    end
  end

  res = next_key_distance.sort_by {|_,key| key.distance}
  @cache[cache_key] = res
end


#######################
# which keys can I see from here?
# [a,c,f,..]

# keys.each do |next_key|
#   take shortest path do
#     go back to start (recursive?)
#   end (undoes key?)
# end

KEYS_TO_FIND = 26

@shortest_distance = 1_000_000

def find_all_keys(row, col, distance=0, found=0)
  if key?(row,col)
    @keys << @map[row][col]
    # p @keys
  end

  v = @map[row][col]
  @map[row][col] = '.'

  if found == KEYS_TO_FIND
    @keys.delete(v)
    @map[row][col] = v
    if distance < @shortest_distance
      @shortest_distance = distance
      p @keys
      puts "found all keys in #{distance} steps"
    end
    return
  end

  keys_to_pick(row,col).each do |_,key|
    # puts "[#{found}:#{distance}] will pick key #{key.key}, at distance #{key.distance}"
    find_all_keys(key.row, key.col, distance+key.distance, found+1)
  end

  # reverse
  @keys.delete(v)
  @map[row][col] = v
end

find_all_keys(@row, @col)
