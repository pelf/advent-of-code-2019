asteroids = []

map = File.readlines("input.txt").map.with_index do |row, r|
  row.strip.chars.map.with_index do |a, c|
    if a == '#'
      asteroids << [r, c]
      true
    else
      false
    end
  end
end

INFINITY = 1_000_000

p map
p asteroids

station = nil
max = -1

asteroids.each do |origin_ast|
  p origin_ast
  sees = {}
  asteroids.each do |target_ast|
    puts "checking #{target_ast}"
    next if origin_ast == target_ast

    r_dist = target_ast[0] - origin_ast[0]
    c_dist = target_ast[1] - origin_ast[1]
    if c_dist != 0
      angle = r_dist / c_dist.to_f
    else
      angle = INFINITY
    end
    dist = r_dist + c_dist

    quad =  if r_dist <= 0
              c_dist <= 0 ? 1 : 2
            else
              c_dist <= 0 ? 3 : 4
            end

    sees["Q#{quad}:#{angle}"] = dist
    puts "  angle: #{angle}, dist: #{dist}"
  end

  puts "sees #{sees.size}"

  if sees.size > max
    puts "  new max!"
    max = sees.size
    station = origin_ast
  end
end

p station
p max
