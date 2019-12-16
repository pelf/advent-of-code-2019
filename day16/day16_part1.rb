input = File.read("input.txt").chomp.chars.map(&:to_i)

PATTERN = [0, 1, 0, -1].freeze
PHASES = 100

PHASES.times do |phase|
  output = Array.new(input.size)
  input.size.times do |i|
    total = 0
    input.each.with_index do |digit, shift|
      pat_shift = ((shift + 1)/(i+1)) % PATTERN.size
      pat = PATTERN[pat_shift]
      total += (digit * pat)
    end
    output[i] = total.abs % 10
  end
  input = output
end

p input[0,8].join('')
