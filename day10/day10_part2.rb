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

Target = Struct.new(:coords, :angle, :quad, :dist)

origin_ast = [36,26]

quads = [{},{},{},{}]

asteroids.each do |target_ast|
  next if origin_ast == target_ast

  r_dist = target_ast[0] - origin_ast[0]
  c_dist = target_ast[1] - origin_ast[1]
  angle = Math.atan(r_dist.to_f / c_dist.to_f)
  dist = r_dist + c_dist

  quad = if c_dist >= 0
    r_dist > 0 ? 1 : 0
  else
    r_dist > 0 ? 2 : 3
  end

  quads[quad][angle] ||= []
  quads[quad][angle] << Target.new(target_ast, angle, quad, dist)
end

angles = quads.map do |quad|
  quad.sort_by { |k,v| k }.map { |k,v| [k, v.sort_by { |t| t.dist.abs } ] }
end.flatten(1)

i = 0

200.times do
  until (t = angles[i%angles.size][1].shift)
    i += 1
  end
  p t
  i += 1
end

