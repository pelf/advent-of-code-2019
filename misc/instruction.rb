class Instruction
  def initialize(opcode, params)
    @opcode = opcode
    @params = params
  end

  def to_s
    "#{operation} #{params}"
  end

  private

  OPERATIONS = {
    1 => "SUM",
    2 => "MUL",
    3 => "IN",
    4 => "OUT",
    5 => "JUZ",
    6 => "JIZ",
    7 => "LT",
    8 => "EQL",
    9 => "BAS",
    99 => "HLT"
  }.freeze

  def operation
    (OPERATIONS[@opcode] || "ERR")
  end

  def params
    @params.join(" ")
  end
end
