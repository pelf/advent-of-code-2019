grid = File.readlines("input.txt").map do |row|
  row.strip.split('').map { |t| t == '#' ? 1 : 0 }
end

SIZE = grid.size

def biodiversity(grid)
  (SIZE*SIZE).times.map do |i|
    # TODO: optimize?
    grid[i/5][i%5] * 2**i
  end.reduce(:+)
end

def tick(grid)
  tmp = Array.new(SIZE) { Array.new(SIZE) }
  grid.each.with_index do |row, r|
    row.each.with_index do |tile, c|
      count = 0
      count += 1 if r > 0 && grid[r-1][c] == 1
      count += 1 if c > 0 && grid[r][c-1] == 1
      count += 1 if r < SIZE - 1 && grid[r+1][c] == 1
      count += 1 if c < SIZE - 1 && grid[r][c+1] == 1

      if tile == 1
        tmp[r][c] = count == 1 ? 1 : 0
      else
        tmp[r][c] = (count == 1 || count == 2) ? 1 : 0
      end
    end
  end
  tmp
end

def print_grid(grid)
  puts `clear`
  grid.each do |row|
    puts row.join('')
  end
end

seen = {}

loop do
  bio = biodiversity(grid)
  if seen[bio]
    puts bio
    break
  end
  seen[bio] = true
  grid = tick(grid)
end
