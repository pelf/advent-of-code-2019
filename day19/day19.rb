require_relative './drone'
require_relative '../misc/machine'

input = File.read("input.txt").chomp

# start in a 1 we found in part 1 where the know the beam is consistent
@row = 49
@col = 30
@count = 0

def print(r, c)
  @squares[r,100].each do |row|
    puts row[c,100].join('')
  end
end

loop do
  puts "#{@row},#{@col}"
  if Drone.new(input, @row, @col).run == 1 # hit the beam!
    if Drone.new(input, @row, @col + 99).run == 1 # it's wide enough!
      if Drone.new(input, @row + 99, @col).run == 1 # it's tall enough!
        # santa's ship fits here
        break
      else # not tall enough, go right
        @col += 1
      end
    else # not wide enough, go down
      @row += 1
    end
  else # did not hit the beam, move right
    @col += 1
  end
end

puts (@col * 10_000 + @row)
