struct Key
  property row, col, key, distance

  def initialize(@row : Int32, @col : Int32, @key : String, @distance : Int32)
  end
end

class Dumb
  @map : Array(Array(String))
  @rows : Int32
  @cols : Int32

  def initialize
    @map = [] of Array(String)

    File.each_line("input2.txt") do |row|
      @map << row.strip.split("")
    end

    @rows = @map.size
    @cols = @map.first.size

    @keys = [] of String
    @cache = {} of String => Array(Tuple(String, Key))

    @robots = [
      [39, 39],
      [39, 41],
      [41, 39],
      [41, 41],
    ]

    find_all_keys(39, 39)
  end

  def print_map
    puts
    @map.each do |row|
      puts row.join("")
    end
    puts
  end

  # crawls maze to find all accessible keys
  def possible_keys(row, col, steps = 0)
    v = @map[row][col]
    if key?(row, col)
      # puts "found key #{v} in #{steps} steps"
      return [Key.new(row, col, v, steps)]
    end

    @map[row][col] = " "
    keys = [] of Key
    possible_moves(row, col).each do |coords|
      r = coords[0]
      c = coords[1]
      keys += possible_keys(r, c, steps + 1)
    end
    @map[row][col] = v
    keys
  end

  def possible_moves(row, col)
    moves = [] of Array(Int32)
    # north
    if row > 0 && free?(row - 1, col)
      moves << [row - 1, col]
    end
    # south
    if row < @rows - 1 && free?(row + 1, col)
      moves << [row + 1, col]
    end
    # west
    if col > 0 && free?(row, col - 1)
      moves << [row, col - 1]
    end
    # east
    if col < @cols - 1 && free?(row, col + 1)
      moves << [row, col + 1]
    end

    moves
  end

  def free?(row, col)
    @map[row][col] == "." || key?(row, col) || @keys.includes?(@map[row][col].downcase)
  end

  def key?(row, col)
    @map[row][col] =~ /[a-z]/
  end

  def keys_to_pick(row, col)
    # check cache
    cache_key = "#{row},#{col}" + @keys.sort.join("")
    return @cache[cache_key] if @cache.has_key?(cache_key)

    next_key_distance = {} of String => Key

    possible_keys(row, col).each do |key|
      if !next_key_distance.has_key?(key.key) || next_key_distance[key.key].distance > key.distance
        next_key_distance[key.key] = key
      end
    end

    res = next_key_distance.to_a.sort_by { |_, key| key.distance }
    @cache[cache_key] = res
  end

  KEYS_TO_FIND = 26

  @shortest_distance = 1_000_000

  def find_all_keys(row, col, distance = 0, found = 0)
    if key?(row, col)
      @keys << @map[row][col]
      # p @keys
    end

    v = @map[row][col]
    @map[row][col] = "."

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

    @robots.each.with_index do |robot, i|
      keys_to_pick(robot[0], robot[1]).each do |_, key|
        tmp = robot.dup
        robot[0] = key.row
        robot[1] = key.col
        # puts "[#{found}:#{distance}] robot #{i} will pick key #{key.key}, at distance #{key.distance}"
        find_all_keys(key.row, key.col, distance + key.distance, found + 1)
        robot[0] = tmp[0]
        robot[1] = tmp[1]
      end
    end

    # reverse
    @keys.delete(v)
    @map[row][col] = v
  end
end

Dumb.new
