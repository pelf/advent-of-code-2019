reactions = {}

File.readlines("input.txt").each do |line|
  # 2 AB, 3 BC, 4 CA => 1 FUEL
  line =~ /(.+)=>(.+)/
  output = $2
  inputs = $1.split(",").map do |input|
    input.strip =~ /(\d+)\s(\w+)/
    # [2, "A"]
    [$1.to_i, $2]
  end
  output =~ /(\d+)\s(\w+)/
  # 'FUEL' => [1, [inputs...]]
  reactions[$2] = [$1.to_i, inputs]
end

requirements = Hash.new { 0 }
used = Hash.new { 0 }
leftover = Hash.new { 0 }

requirements['FUEL'] = 1

loop do
  chemical, qty = requirements.shift

  if leftover[chemical] > 0
    lo_qty = [leftover[chemical], qty].min
    qty -= lo_qty
    leftover[chemical] -= lo_qty
  end
  produces, inputs = reactions[chemical]
  nr_batches = (qty.to_f/produces).ceil
  lo_qty = (nr_batches * produces) - qty
  leftover[chemical] += lo_qty

  inputs.each do |qty, input|
    unless input == 'ORE'
      requirements[input] += (qty * nr_batches)
    end
    used[input] += qty * nr_batches
  end

  break if requirements.empty?
end

p used
