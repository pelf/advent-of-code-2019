grid = File.readlines("input.txt").map do |row|
  row.strip.split('').map { |t| t == '#' ? 1 : 0 }
end

SIZE = 5

# 5 x 5 x 4+ (W,N,E,S) neighbours
# each neighbour is: [level_change, x, y]
ADJACENT = [
  [ # row 0
    [[-1,2,1],[-1,1,2],[0,0,1],[0,1,0]], # 0,0
    [[0,0,0],[-1,1,2],[0,0,2],[0,1,1]], # 0,1
    [[0,0,1],[-1,1,2],[0,0,3],[0,1,2]], # 0,2
    [[0,0,2],[-1,1,2],[0,0,4],[0,1,3]], # 0,3
    [[0,0,3],[-1,1,2],[-1,2,3],[0,1,4]], # 0,4
  ], [ # row 1
    [[-1,2,1],[0,0,0],[0,1,1],[0,2,0]], # 1,0
    [[0,1,0],[0,0,1],[0,1,2],[0,2,1]], # 1,1
    [[0,1,1],[0,0,2],[0,1,3],[1,0,0],[1,0,1],[1,0,2],[1,0,3],[1,0,4]], # 1,2
    [[0,1,2],[0,0,3],[0,1,4],[0,2,3]], # 1,3
    [[0,1,3],[0,0,4],[-1,2,3],[0,2,4]], # 1,4
  ], [ # row 2
    [[-1,2,1],[0,1,0],[0,2,1],[0,3,0]], # 2,0
    [[0,2,0],[0,1,1],[1,0,0],[1,1,0],[1,2,0],[1,3,0],[1,4,0],[0,3,1]], # 2,1
    [],# skip 2,2
    [[1,0,4],[1,1,4],[1,2,4],[1,3,4],[1,4,4],[0,1,3],[0,2,4],[0,3,3]], # 2,3
    [[0,2,3],[0,1,3],[-1,2,3],[0,3,4]], # 2,4
  ], [ # row 3
    [[-1,2,1],[0,2,0],[0,3,1],[0,4,0]], # 3,0
    [[0,3,0],[0,2,1],[0,3,2],[0,4,1]], # 3,1
    [[0,3,1],[1,4,0],[1,4,1],[1,4,2],[1,4,3],[1,4,4],[0,3,3],[0,4,2]], # 3,2
    [[0,3,2],[0,2,3],[0,3,4],[0,4,3]], # 3,3
    [[0,3,3],[0,2,4],[-1,2,3],[0,4,4]], # 3,4
  ], [ # row 4
    [[-1,2,1],[0,3,0],[0,4,1],[-1,3,2]], # 4,0
    [[0,4,0],[0,3,1],[0,4,2],[-1,3,2]], # 4,1
    [[0,4,1],[0,3,2],[0,4,3],[-1,3,2]], # 4,2
    [[0,4,2],[0,3,3],[0,4,4],[-1,3,2]], # 4,3
    [[0,4,3],[0,3,4],[-1,2,3],[-1,3,2]], # 4,4
  ]
]

def tick(levels, lvl)
  tmp = Array.new(SIZE) { Array.new(SIZE) }

  levels[lvl].each.with_index do |row, r|
    row.each.with_index do |tile, c|
       # skip middle tile
      if r == 2 && c == 2
        tmp[2][2] = '?'
        next
      end

      count = ADJACENT[r][c].map do |lvl_offset, r2, c2|
        levels[lvl + lvl_offset][r2][c2]
      end.reduce(:+)

      puts "L#{lvl}:#{r},#{c} has #{count} bugs around"

      if tile == 1 # a bug remains a bug if it has exactly 1 bug as neighbour
        tmp[r][c] = (count == 1) ? 1 : 0
      else # an empty tile gets a bug if it has 1 or 2 bugs as neighbours
        tmp[r][c] = (count == 1 || count == 2) ? 1 : 0
      end
    end
  end

  tmp
end

def print_grid(grid, lvl)
  puts "\nL#{lvl}:"
  grid.each do |row|
    puts row.join('')
  end
end

MID_LEVEL = 100

levels = (MID_LEVEL*2 + 1).times.map do
  # each level has a 5x5 (empty) grid
  Array.new(SIZE) { Array.new(SIZE) { 0 } }
end
# initialize middle grid with input
levels[MID_LEVEL] = grid


print_grid(grid, 0)

(1..1).each do |minute|
  puts "\n\nMINUTE #{minute}"
  # ugly hack to dup levels so we can store the results of ticks
  ticked_levels = Marshal.load(Marshal.dump(levels))

  # we don't need to process every level, only process as bugs expand (2 ticks per level)
  lvl_offset = (minute + 1) / 2
  ((MID_LEVEL-lvl_offset)..(MID_LEVEL+lvl_offset)).each do |lvl|
    # tick this level
    ticked_levels[lvl] = tick(levels, lvl)
    print_grid ticked_levels[lvl], lvl
  end

  # swap levels with ticked levels
  levels = ticked_levels
end
