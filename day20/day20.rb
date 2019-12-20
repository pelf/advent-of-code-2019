input = File.readlines("input.txt").map do |row|
  row.split("")
end

ROWS = input.size
COLS = input.map(&:size).max

def print_map(input)
  input.each do |row|
    puts row.join('')
  end
  puts `clear`
end

def free?(squares, row, col)
  squares[row][col] == '.' || squares[row][col] =~ /[A-Z]/
end

def adjacent_squares(squares, row, col)
  sqs = []
  # north
  if row > 0 && free?(squares, row-1, col)
    sqs << [squares[row-1][col], row-1,col]
  end
  # south
  if row < ROWS - 1 && free?(squares, row+1, col)
    sqs << [squares[row+1][col], row+1,col]
  end
  # west
  if col > 0 && free?(squares, row, col-1)
    sqs << [squares[row][col-1], row,col-1]
  end
  # east
  if col < COLS - 1 && free?(squares, row, col+1)
    sqs << [squares[row][col+1], row,col+1]
  end

  sqs
end

def detect_portals(input)
  portals = {}

  input.each.with_index do |row, r|
    row.each.with_index do |sq, c|

      portal = nil
      label = nil

      if sq =~ /[A-Z]/
        adjacent_squares(input, r, c).each do |sq2, r2, c2|
          if sq2 == '.'
            # portal entry found
            portal = [r2,c2]
          elsif sq2 =~ /[A-Z]/
            # now we need to "read" the label in the correct order
            if r2 > r || c2 > c
              label = sq + sq2
            else
              label = sq2 + sq
            end
          end
        end

        if portal
          portals[label] ||= []
          portals[label] << portal
        end
      end
    end
  end

  portals
end

# crawls maze to find all routes to exit
def shortest_path(input, portals, portal_links, row, col, steps=0)
  # puts "#{row}, #{col}: #{steps}"

  v = input[row][col]
  input[row][col] = ' '
  # print_map(input)

  min_dist = adjacent_squares(input, row, col).map do |sq, r, c|
    if (other_side = portal_links[[r,c]])
      # puts "portal! from #{[r,c]} to #{other_side}"
      # this is a portal entry, teleport!
      shortest_path(input, portals, portal_links, other_side[0], other_side[1], steps + 2)
    elsif [r,c] == portals["ZZ"].first
      puts "found exit in #{steps + 1} steps"
      steps + 1
    else
      shortest_path(input, portals, portal_links, r, c, steps + 1)
    end
  end.compact.min

  input[row][col] = v
  min_dist
end

# portals has { "AA" => [[coords]], "QI" => [[coords],[coords]], etc...}
@portals = detect_portals(input)
# portal_links has { [coords1] => [coords2], [coords2] => [coords1], [coords3] => [coords4], ... }
@portal_links = {}
@portals.each do |label, portals|
  # ignore entry and exit
  if portals.size > 1
    @portal_links[portals[0]] = portals[1]
    @portal_links[portals[1]] = portals[0]
  end
end

p @portals
p @portal_links

starting_row, starting_col = @portals["AA"].first
p shortest_path(input, @portals, @portal_links, starting_row, starting_col)
