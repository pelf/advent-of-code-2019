class Body
  attr_reader :pos, :vel

  def initialize(x, y, z)
    @pos = [x, y, z]
    @vel = [0, 0, 0]
  end

  def energy
    pot * kin
  end

  def to_s
    # "#{pos}#{vel}"
    "#{pos[0]}"
  end

  private

  def pot
    pos[0].abs + pos[1].abs + pos[2].abs
  end

  def kin
    vel[0].abs + vel[1].abs + vel[2].abs
  end
end

bodies = File.readlines("input.txt").map do |line|
  # <x=14, y=2, z=8>
  line =~ /<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/
  Body.new($1.to_i, $2.to_i, $3.to_i)
end

states = {}
i = 0

initial_xs = bodies.map { |b| b.pos[0] }
initial_ys = bodies.map { |b| b.pos[1] }
initial_zs = bodies.map { |b| b.pos[2] }
initial_velx = bodies.map { |b| b.vel[0] }
initial_vely = bodies.map { |b| b.vel[1] }
initial_velz = bodies.map { |b| b.vel[2] }

cycles_found = [false] * 6

loop do
  i += 1

  # gravity step
  bodies.combination(2).each do |b1, b2|
    (0..2).each do |axis|
      if b1.pos[axis] > b2.pos[axis]
        b1.vel[axis] -= 1
        b2.vel[axis] += 1
      elsif b2.pos[axis] > b1.pos[axis]
        b1.vel[axis] += 1
        b2.vel[axis] -= 1
      end
    end
  end

  # velocity step
  bodies.each do |body|
    (0..2).each do |axis|
      body.pos[axis] += body.vel[axis]
    end
  end

  if bodies.map { |b| b.pos[0] } == initial_xs && !cycles_found[0]
    cycles_found[0] = i + 1 # positions happen twice at top and bottom of the cycle
  end
  if bodies.map { |b| b.pos[1] } == initial_ys && !cycles_found[1]
    cycles_found[1] = i + 1 # positions happen twice at top and bottom of the cycle
  end
  if bodies.map { |b| b.pos[2] } == initial_zs && !cycles_found[2]
    cycles_found[2] = i + 1 # positions happen twice at top and bottom of the cycle
  end

  if bodies.map { |b| b.vel[0] } == initial_velx && !cycles_found[3]
    cycles_found[3] = i
  end
  if bodies.map { |b| b.vel[1] } == initial_vely && !cycles_found[4]
    cycles_found[4] = i
  end
  if bodies.map { |b| b.vel[2] } == initial_velz && !cycles_found[5]
    cycles_found[5] = i
  end

  break if cycles_found.all?
end

puts "Find the LMC for these numbers: (google it)"
p cycles_found.sort
