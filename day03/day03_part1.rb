# --- Day 3: Crossed Wires ---
# The gravity assist was successful, and you're well on your way to the Venus refuelling station. During the rush back on Earth, the fuel management system wasn't completely installed, so that's next on the priority list.

# Opening the front panel reveals a jumble of wires. Specifically, two wires are connected to a central port and extend outward on a grid. You trace the path each wire takes as it leaves the central port, one wire per line of text (your puzzle input).

# The wires twist and turn, but the two wires occasionally cross paths. To fix the circuit, you need to find the intersection point closest to the central port. Because the wires are on a grid, use the Manhattan distance for this measurement. While the wires do technically cross right at the central port where they both start, this point does not count, nor does a wire count as crossing with itself.

# For example, if the first wire's path is R8,U5,L5,D3, then starting from the central port (o), it goes right 8, up 5, left 5, and finally down 3:

# ...........
# ...........
# ...........
# ....+----+.
# ....|....|.
# ....|....|.
# ....|....|.
# .........|.
# .o-------+.
# ...........
# Then, if the second wire's path is U7,R6,D4,L4, it goes up 7, right 6, down 4, and left 4:

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
# These wires cross at two locations (marked X), but the lower-left one is closer to the central port: its distance is 3 + 3 = 6.

# Here are a few more examples:

# R75,D30,R83,U83,L12,D49,R71,U7,L72
# U62,R66,U55,R34,D71,R55,D58,R83 = distance 159
# R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
# U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = distance 135
# What is the Manhattan distance from the central port to the closest intersection?

Segment = Struct.new(:starts, :ends) do
  def vertical?
    starts[0] == ends[0]
  end
end

wires = File.foreach("input.txt").map { |wire| wire.split(',') }.to_a

wires = wires.map do |wire|
  starts = [0,0]
  segments = []
  # probs not needed
  max_x, min_x, max_y, min_y = 0, 0, 0, 0

  wire.each do |segment|
    segment =~ /(\w)(\d+)/
    dir = $1
    dist = $2.to_i
    case dir
    when "R"
      new_x = (starts[0] + dist)
      ends = [new_x, starts[1]]
      segment = Segment.new(starts, ends)
      # max_x = new_x if new_x > max_x
    when "L"
      new_x = (starts[0] - dist)
      ends = [new_x, starts[1]]
      segment = Segment.new(ends, starts)
      # min_x = new_x if new_x < min_x
    when "U"
      new_y = (starts[1] + dist)
      ends = [starts[0], new_y]
      segment = Segment.new(starts, ends)
      # max_y = new_y if new_y > max_y
    when "D"
      new_y = (starts[1] - dist)
      ends = [starts[0], new_y]
      segment = Segment.new(ends, starts)
      # min_y = new_y if new_y < min_y
    else
      raise "Oops!"
    end
    segments << segment
    starts = ends
  end

  segments
end

min_dist = 1000000000

wires[0].each do |segment_1|
  wires[1].each do |segment_2|
    if segment_1.vertical? && !segment_2.vertical?
      if segment_1.starts[1] <= segment_2.starts[1] && segment_1.ends[1] >= segment_2.starts[1] && segment_2.starts[0] <= segment_1.starts[0] && segment_2.ends[0] >= segment_1.starts[0]
          p "", segment_1, segment_2
          x = segment_1.starts[0]
          y = segment_2.starts[1]
          dist = x.abs + y.abs
          min_dist = dist if dist < min_dist
      end
    elsif !segment_1.vertical? && segment_2.vertical?
      if segment_2.starts[1] <= segment_1.starts[1] && segment_2.ends[1] >= segment_1.starts[1] && segment_1.starts[0] <= segment_2.starts[0] && segment_1.ends[0] >= segment_2.starts[0]
          p "", segment_1, segment_2
          x = segment_1.starts[1]
          y = segment_2.starts[0]
          dist = x.abs + y.abs
          min_dist = dist if dist < min_dist
      end
    end
  end
end

p min_dist
