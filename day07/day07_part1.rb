def read_params(nr, mode1="1", mode2="1")
  param1 = @insts[@pos+1].to_i
  param1 = @insts[param1].to_i if mode1 == "0"
  return param1 if nr == 1

  param2 = @insts[@pos+2].to_i
  param2 = @insts[param2].to_i if mode2 == "0"
  return param1, param2 if nr == 2

  param3 = @insts[@pos+3].to_i
  return param1, param2, param3
end

max_result = 0

(0..4).to_a.permutation.each do |phases|
  amp_input = 0

  phases.each do |phase|
    code = "3,8,1001,8,10,8,105,1,0,0,21,46,59,84,93,102,183,264,345,426,99999,3,9,1002,9,4,9,1001,9,3,9,102,2,9,9,1001,9,5,9,102,3,9,9,4,9,99,3,9,1002,9,3,9,101,4,9,9,4,9,99,3,9,1002,9,4,9,1001,9,4,9,102,2,9,9,1001,9,2,9,1002,9,3,9,4,9,99,3,9,1001,9,5,9,4,9,99,3,9,1002,9,4,9,4,9,99,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99"
    @insts = code.split(",")
    @pos = 0

    read_phase = false

    loop do
      inst = @insts[@pos].dup

      if inst.size > 2
        opcode = inst.slice!(-2,2).to_i
        mode1 = inst.slice!(-1,1)
        mode2 = inst.slice!(-1,1) || "0"
        mode3 = inst.slice!(-1,1) || "0"
      else
        opcode = inst.to_i
        mode1 = mode2 = mode3 = "0"
      end

      case opcode
      when 1 # sum
        param1, param2, param3 = read_params(3, mode1, mode2)
        sum = param1 + param2
        @insts[param3] = sum.to_s
        @pos += 4
      when 2 # mult
        param1, param2, param3 = read_params(3, mode1, mode2)
        mult = param1 * param2
        @insts[param3] = mult.to_s
        @pos += 4
      when 3 # input
        if read_phase
          input = amp_input
        else
          input = phase
          read_phase = true
        end
        param1 = read_params(1)
        @insts[param1] = input
        @pos += 2
      when 4 # output
        param1 = read_params(1, "0")
        amp_input = param1
        @pos += 2
      when 5 # jump unless zero
        param1, param2 = read_params(2, mode1, mode2)
        @pos = param1 != 0 ? param2 : (@pos + 3)
      when 6 # jump if zero
        param1, param2 = read_params(2, mode1, mode2)
        @pos = param1 == 0 ? param2 : (@pos + 3)
      when 7 # less than
        param1, param2, param3 = read_params(3, mode1, mode2)
        @insts[param3] = param1 < param2 ? "1" : "0"
        @pos += 4
      when 8 # equals
        param1, param2, param3 = read_params(3, mode1, mode2)
        @insts[param3] = param1 == param2 ? "1" : "0"
        @pos += 4
      when 99
        break
      else
        raise "oops!"
      end
    end
  end

  max_result = amp_input if amp_input > max_result
end

puts max_result
