# --- Part Two ---
# It turns out that this circuit is very timing-sensitive; you actually need to minimize the signal delay.

# To do this, calculate the number of steps each wire takes to reach each intersection; choose the intersection where the sum of both wires' steps is lowest. If a wire visits a position on the grid multiple times, use the steps value from the first time it visits that position when calculating the total value of a specific intersection.

# The number of steps a wire takes is the total number of grid squares the wire has entered to get to that location, including the intersection being considered. Again consider the example from above:

# ...........
# .+-----+...
# .|.....|...
# .|..+--X-+.
# .|..|..|.|.
# .|.-X--+.|.
# .|..|....|.
# .|.......|.
# .o-------+.
# ...........
# In the above example, the intersection closest to the central port is reached after 8+5+5+2 = 20 steps by the first wire and 7+6+4+3 = 20 steps by the second wire for a total of 20+20 = 40 steps.

# However, the top-right intersection is better: the first wire takes only 8+5+2 = 15 and the second wire takes only 7+6+2 = 15, a total of 15+15 = 30 steps.

# Here are the best steps for the extra examples from above:

# R75,D30,R83,U83,L12,D49,R71,U7,L72
# U62,R66,U55,R34,D71,R55,D58,R83 = 610 steps
# R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
# U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = 410 steps
# What is the fewest combined steps the wires must take to reach an intersection?


class Segment
  attr_reader :starts, :ends, :start_dist, :reverse

  def initialize(starts, ends, start_dist, reverse: false)
    @starts = starts
    @ends = ends
    @start_dist = start_dist
    @reverse = reverse
  end

  def left_end
    raise 'Vertical segments have no left end' if vertical?
    return ends if reverse
    starts
  end

  def right_end
    raise 'Vertical segments have no right end' if vertical?
    return starts if reverse
    ends
  end

  def x
    raise 'Horizontal segments have multiple X values' if horizontal?
    starts[0]
  end

  def top_end
    raise 'Horizontal segments have no top end' if horizontal?
    return ends if reverse
    starts
  end

  def bottom_end
    raise 'Horizontal segments have no bottom end' if horizontal?
    return starts if reverse
    ends
  end

  def y
    raise 'Vertical segments have multiple Y values' if vertical?
    starts[1]
  end

  def vertical?
    starts[0] == ends[0]
  end

  def horizontal?
    !vertical?
  end

  def wire_dist_to(point)
    puts "checking distance to point #{point}"
    if horizontal?
      start_dist + (starts[0] - point[0]).abs
    else
      start_dist + (starts[1] - point[1]).abs
    end
  end

  def intersection(segment)
    if vertical? && segment.horizontal?
      if x > segment.left_end[0] && x < segment.right_end[0] && segment.y > top_end[1] && segment.y < bottom_end[1]
        point = [x, segment.y]
        return wire_dist_to(point) + segment.wire_dist_to(point)
      end
    elsif horizontal? && segment.vertical?
      if segment.x > left_end[0] && segment.x < right_end[0] && y > segment.top_end[1] && y < segment.bottom_end[1]
        point = [segment.x, y]
        return wire_dist_to(point) + segment.wire_dist_to(point)
      end
    end

    nil
  end
end

wires = File.foreach("input.txt").map { |wire| wire.split(',') }.to_a

wires = wires.map do |wire|
  starts = [0,0]
  segments = []
  total_dist = 0

  wire.each do |segment|
    segment =~ /(\w)(\d+)/
    dir = $1
    dist = $2.to_i
    case dir
    when "R"
      new_x = (starts[0] + dist)
      ends = [new_x, starts[1]]
      segment = Segment.new(starts, ends, total_dist)
    when "L"
      new_x = (starts[0] - dist)
      ends = [new_x, starts[1]]
      segment = Segment.new(starts, ends, total_dist, reverse: true)
    when "U"
      new_y = (starts[1] + dist)
      ends = [starts[0], new_y]
      segment = Segment.new(starts, ends, total_dist)
    when "D"
      new_y = (starts[1] - dist)
      ends = [starts[0], new_y]
      segment = Segment.new(starts, starts, total_dist, reverse: true)
    else
      raise "Woot!?"
    end
    segments << segment
    starts = ends
    total_dist += dist
    puts "#{segment} #{total_dist}"
  end

  segments
end

min_dist = 1000000000

wires[0].each do |segment_1|
  wires[1].each do |segment_2|
    if (distance = segment_1.intersection(segment_2))
      p "", segment_1, segment_2
      min_dist = distance if distance < min_dist
    end
  end
end

p min_dist
