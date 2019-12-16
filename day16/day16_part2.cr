PHASES = 100
input = File.read("input.txt").chomp.chars.map { |c| c.to_i } * 10_000
offset = input[0,7].join("").to_i
input = input[offset..-1].reverse
output = Array.new(input.size) { 0 }

PHASES.times do |phase|
  out = 0
  input.each.with_index do |digit, i|
    out = (out + digit) % 10
    output[i] = out
  end
  input = output
end

p input.reverse[0,8].join("")
