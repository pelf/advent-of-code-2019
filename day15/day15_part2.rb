@map = File.readlines("input2.txt").map do |row|
  row.chomp.split('')
end

def print_map
  @map.each do |row|
    puts row.join('')
  end
end

minute = 0

loop do
  puts minute
  print_map

  new_map = Marshal.load( Marshal.dump(@map) )

  # iterate dup map and make changes to original map
  new_map.each.with_index do |row, r|
    row.each.with_index do |val, c|
      if val == 'O'
        # north
        if r > 0 && new_map[r-1][c] == '.'
          @map[r-1][c] = 'O'
        end
        # south
        if r < new_map.size - 1 && new_map[r+1][c] == '.'
          @map[r+1][c] = 'O'
        end
        # west
        if c > 0 && new_map[r][c-1] == '.'
          @map[r][c-1] = 'O'
        end
        # east
        if c < row.size - 1 && new_map[r][c+1] == '.'
          @map[r][c+1] = 'O'
        end
      end
    end
  end

  minute += 1

  gets
  puts `clear`
end
