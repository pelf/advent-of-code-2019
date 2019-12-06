class Body
  attr_accessor :orbits, :orbitters, :orbit_count, :visited

  def initialize
    @orbitters = []
  end
end

@bodies = {}

File.readlines('input.txt').each do |orbit|
  if orbit =~ /(\w+)\)(\w+)/
    @bodies[$1] ||= Body.new
    @bodies[$1].orbitters << $2
    @bodies[$2] ||= Body.new
    @bodies[$2].orbits = $1
  else
    raise "oops!"
  end
end

# p @bodies

def count_orbits(body)
  orbit_count = 0
  while body.orbits
    orbit_count += 1
    body = @bodies[body.orbits]
    # use cache
    if body.orbit_count
      orbit_count += body.orbit_count
      break
    end
  end
  orbit_count
end

total_orbits = 0

@bodies.each do |name, body|
  orbit_count = count_orbits(body)
  total_orbits += orbit_count
  body.orbit_count = orbit_count # cache
end

puts total_orbits

def search_santa(body)
  body.visited = true

  return 0 if body.orbits == 'SAN' || body.orbitters.include?('SAN')

  # upstream
  body.orbitters.each do |orbitter|
    orbitter = @bodies[orbitter]
    next if orbitter.visited

    res = search_santa(orbitter)
    return res + 1 if res
  end

  # downstream
  orbitted = @bodies[body.orbits]
  unless orbitted.visited
    res = search_santa(orbitted)
    return res + 1 if res
  end

  nil
end

puts search_santa(@bodies['YOU'])
