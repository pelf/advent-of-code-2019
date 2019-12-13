class Param
  attr_accessor :mode, :val, :pos, :output

  def initialize(mode, val, pos = nil, output: false)
    @mode = mode
    @val = val
    @pos = pos
    @output = output
  end

  def to_s
    if output
      "#{val}>[#{pos}]"
    else
      mode == 1 ? val.to_s : "#{val}[#{pos}]"
    end
  end
end
