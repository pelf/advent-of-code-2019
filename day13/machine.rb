class Machine
  attr_reader :insts, :pos, :base, :io

  def initialize(input, io)
    @insts = input.split(",")
    @pos = 0
    @base = 0
    @io = io

    # part 2: set address 0 to 2
    @insts[0] = "2"
  end

  def run
    loop do
      inst = insts[@pos].dup
      # puts " ------ "
      # p "[#{@pos}]", inst, insts

      if inst.size > 2
        opcode = inst.slice!(-2,2).to_i
        mode1 = inst.slice!(-1,1)
        mode2 = inst.slice!(-1,1) || "0"
        mode3 = inst.slice!(-1,1) || "0"
      else
        opcode = inst.to_i
        mode1 = mode2 = mode3 = "0"
      end

      # puts "#{opcode} #{mode1} #{mode2} #{mode3}"

      case opcode
      when 1 # sum
        param1, param2, param3 = read_params(3, mode1, mode2)
        sum = param1 + param2
        param3 += @base if mode3 == "2"
        insts[param3] = sum.to_s
        # puts "summing #{param1} + #{param2} = #{sum} into #{param3}"
        @pos += 4
      when 2 # mult
        param1, param2, param3 = read_params(3, mode1, mode2)
        mult = param1 * param2
        param3 += @base if mode3 == "2"
        insts[param3] = mult.to_s
        # puts "multing #{param1} * #{param2} = #{sum} into #{param3}"
        @pos += 4
      when 3 # input
        input = io.read
        param1 = read_params(1)
        param1 += @base if mode1 == "2"
        insts[param1] = input
        # puts "input #{input} into #{param1}"
        @pos += 2
      when 4 # output
        param1 = read_params(1, mode1)
        # puts "output: #{param1}"
        io.write(param1)
        @pos += 2
      when 5 # jump unless zero
        param1, param2 = read_params(2, mode1, mode2)
        # puts "jump unless zero #{param1} -> #{param2}"
        @pos = param1 != 0 ? param2 : (@pos + 3)
      when 6 # jump if zero
        param1, param2 = read_params(2, mode1, mode2)
        # puts "jump if zero #{param1} -> #{param2}"
        @pos = param1 == 0 ? param2 : (@pos + 3)
      when 7 # less than
        param1, param2, param3 = read_params(3, mode1, mode2)
        param3 += @base if mode3 == "2"
        insts[param3] = param1 < param2 ? "1" : "0"
        # puts "less than #{param1} < #{param2} ? [#{param3}] = #{insts[param3]}"
        @pos += 4
      when 8 # equals
        param1, param2, param3 = read_params(3, mode1, mode2)
        param3 += @base if mode3 == "2"
        insts[param3] = param1 == param2 ? "1" : "0"
        # puts "equals #{param1} == #{param2} ? [#{param3}] = #{insts[param3]}"
        @pos += 4
      when 9
        param1 = read_params(1, mode1)
        @base += param1
        # puts " moved @base to #{@base}"
        @pos += 2
      when 99
        io.halt
        break
      else
        raise "oops!"
      end
    end
  end

  private

  def read_params(nr, mode1="1", mode2="1")
    param1 = @insts[@pos+1].to_i
    if mode1 == "0"
      param1 = @insts[param1].to_i
    elsif mode1 == "2"
      param1 = @insts[base + param1].to_i
    end
    # puts "p1: #{param1} (mode #{mode1})  [base = #{base}]"
    return param1 if nr == 1

    param2 = @insts[@pos+2].to_i
    if mode2 == "0"
      param2 = @insts[param2].to_i
    elsif mode2 == "2"
      param2 = @insts[base + param2].to_i
    end
    # puts "p2: #{param2} (mode #{mode2})"
    return param1, param2 if nr == 2

    param3 = @insts[@pos+3].to_i
    # puts "p3: #{param3}"
    return param1, param2, param3
  end
end
