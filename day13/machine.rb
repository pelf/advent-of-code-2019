require_relative '../misc/debugger'
require_relative '../misc/param'

class Machine
  attr_reader :insts, :pos, :base, :io, :debugger

  def initialize(input, io)
    @insts = input.split(",")
    @pos = 0
    @base = 0
    @io = io
    @debugger = Debugger.new(enabled: true)

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

      param1 = param2 = param3 = nil

      # puts "#{opcode} #{mode1} #{mode2} #{mode3}"
      case opcode
      when 1 # sum
        param1, param2, param3 = read_params(3, mode1, mode2, mode3)
        sum = param1.val + param2.val
        insts[param3.pos] = sum.to_s
        param3.val = sum
        # puts "summing #{param1} + #{param2} = #{sum} into #{param3}"
        @pos += 4
      when 2 # mult
        param1, param2, param3 = read_params(3, mode1, mode2, mode3)
        mult = param1.val * param2.val
        insts[param3.pos] = mult.to_s
        param3.val = mult
        # puts "multing #{param1} * #{param2} = #{sum} into #{param3}"
        @pos += 4
      when 3 # input
        input = io.read
        param1 = read_params(1)
        # FIXME
        param1 = Param.new(param1.mode, input, param1.val, output: true)
        if mode1 == "2"
          param1.mode = 2
          param1.pos = param1.pos + @base
        end
        insts[param1.pos] = input
        # puts "input #{input} into #{param1}"
        @pos += 2
      when 4 # output
        param1 = read_params(1, mode1)
        param1.output = true
        # puts "output: #{param1}"
        io.write(param1.val)
        @pos += 2
      when 5 # jump unless zero
        param1, param2 = read_params(2, mode1, mode2)
        # puts "jump unless zero #{param1} -> #{param2}"
        @pos = param1.val != 0 ? param2.val : (@pos + 3)
      when 6 # jump if zero
        param1, param2 = read_params(2, mode1, mode2)
        # puts "jump if zero #{param1} -> #{param2}"
        @pos = param1.val == 0 ? param2.val : (@pos + 3)
      when 7 # less than
        param1, param2, param3 = read_params(3, mode1, mode2, mode3)
        res = param1.val < param2.val ? "1" : "0"
        insts[param3.pos] = res
        # puts "less than #{param1} < #{param2} ? [#{param3}] = #{insts[param3]}"
        @pos += 4
      when 8 # equals
        param1, param2, param3 = read_params(3, mode1, mode2, mode3)
        res = param1.val == param2.val ? "1" : "0"
        insts[param3.pos] = res
        # puts "equals #{param1} == #{param2} ? [#{param3}] = #{insts[param3]}"
        @pos += 4
      when 9
        param1 = read_params(1, mode1)
        @base += param1.val
        # puts " moved @base to #{@base}"
        @pos += 2
      when 99
        io.halt
        break
      else
        raise "oops!"
      end

      debugger.add(@pos, opcode, [param1, param2, param3].compact)
    end
  end

  private

  def read_params(nr, mode1="1", mode2="1", mode3="0")
    val = @insts[@pos+1].to_i
    param1 = if mode1 == "0"
      Param.new(0, @insts[val].to_i, val)
    elsif mode1 == "2"
      Param.new(2, @insts[base + val].to_i, base+val)
    else
      Param.new(1, val)
    end
    # puts "p1: #{param1} (mode #{mode1})  [base = #{base}]"
    return param1 if nr == 1

    val = @insts[@pos+2].to_i
    param2 = if mode2 == "0"
      Param.new(0, @insts[val].to_i, val)
    elsif mode2 == "2"
      Param.new(2, @insts[base + val].to_i, base+val)
    else
      Param.new(1, val)
    end
    # puts "p2: #{param2} (mode #{mode2})"
    return param1, param2 if nr == 2

    val = @insts[@pos+3].to_i
    param3 = if mode3 == "0"
      Param.new(1, nil, val, output: true)
    elsif mode3 == "2"
      Param.new(2, nil, val + @base, output: true)
    end
    # puts "p3: #{param3}"
    return param1, param2, param3
  end
end
