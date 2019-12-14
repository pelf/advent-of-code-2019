reactions = {}

File.readlines("input.txt").each do |line|
  # 2 AB, 3 BC, 4 CA => 1 FUEL
  line =~ /(.+)=>(.+)/
  output = $2
  inputs = $1.split(",").map do |input|
    input.strip =~ /(\d+)\s(\w+)/
    # [2, "AB"]
    [$1.to_i, $2]
  end
  output =~ /(\d+)\s(\w+)/
  # 'FUEL' => [1, [inputs...]]
  reactions[$2] = [$1.to_i, inputs]
end

requirements = Hash.new { 0 }
used = Hash.new { 0 }
leftover = Hash.new { 0 }

stop_producing = false
fuel = 0

loop do
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
      used[input] += qty * nr_batches

      if input == 'ORE'
        if used['ORE'] > 1_000_000_000_000
          stop_producing = true
          break
        end
      else
        requirements[input] += (qty * nr_batches)
      end
    end

    break if requirements.empty?
  end

  break if stop_producing
  fuel += 1
end

p fuel
