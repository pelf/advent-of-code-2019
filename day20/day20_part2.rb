input = File.readlines("input.txt").map do |row|
  row.split("")
end

ROWS = input.size
COLS = input.map(&:size).max

def print_map(input)
  puts `clear`
  input.each do |row|
    puts row.join('')
  end
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
def shortest_path(input, portals, portal_links, used_portals, row, col, steps=0, level=0)
  # puts "#{row}, #{col} : #{steps} steps :  L#{level}"

  v = input[row][col]
  input[row][col] = ' '
  # print_map(input) if level > 8
  # sleep 0.1

  min_dist = adjacent_squares(input, row, col).map do |sq, r, c|
    if (other_side = portal_links[[r,c]]) #&& !used_portals.include?([r,c]) # teleport if it's an unused portal entry
      # print_map(input)
      if (r > 3 && r < ROWS - 4) && (c > 3 && c < COLS - 4) && level < 10
        puts "Recurse into L#{level + 1} through #{@portal_labels[[r,c]]} - #{[r,c]}->#{other_side}"
        # if it's an inner portal, we go down a level (+1), otherwise we go back up to zero (-1)
        shortest_path(dup(@original_input), portals, portal_links, (used_portals + [[r,c]]), other_side[0], other_side[1], steps + 2, level + 1)
      elsif level > 0 # can't user outer portals on level 0
        puts "Return to L#{level - 1} through #{@portal_labels[[r,c]]} - #{[r,c]}->#{other_side}"
        shortest_path(dup(@original_input), portals, portal_links, (used_portals + [[r,c]]), other_side[0], other_side[1], steps + 2, level - 1)
      end
    elsif [r,c] == [2,13] && level == 0 # portals["ZZ"].first
      puts "found exit in #{steps + 1} steps"
      steps + 1
    else
      shortest_path(input, portals, portal_links, used_portals, r, c, steps + 1, level)
    end
  end.compact.min

  input[row][col] = v
  min_dist
end

# portals has { "AA" => [[coords]], "QI" => [[coords],[coords]], etc...}
@portals = detect_portals(input)
# portal_links has { [coords1] => [coords2], [coords2] => [coords1], [coords3] => [coords4], ... }
@portal_links = {}
@portal_labels = {}
@portals.each do |label, portals|
  # ignore entry and exit
  if portals.size > 1
    @portal_links[portals[0]] = portals[1]
    @portal_links[portals[1]] = portals[0]
    @portal_labels[portals[0]] = label
    @portal_labels[portals[1]] = label
  end
end

p @portals
p @portal_links

def dup(map)
  Marshal.load( Marshal.dump(map))
end

@original_input = dup(input)

starting_row, starting_col = @portals["AA"].first
p shortest_path(input, @portals, @portal_links, [], starting_row, starting_col)
