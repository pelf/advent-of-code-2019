class Body
  attr_reader :pos, :vel

  def initialize(x, y, z)
    @pos = [x, y, z]
    @vel = [0, 0, 0]
  end

  def energy
    pot * kin
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

1_000.times do
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
end

p bodies.map(&:energy).reduce(:+)
