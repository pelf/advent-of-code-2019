require 'curses'
require_relative './instruction'
require_relative './param'

class Debugger
  def initialize(enabled: true)
    Curses.init_screen
    @height = Curses.lines
    @width = Curses.cols
    @window = Curses::Window.new(@height, (@width / 3) * 2, 0, (@width / 3))

    @instructions = {}
    @viewport_shift = 0
    # :split or :scroll
    @display_mode = :split
    @enabled = enabled
  end

  def add(pos, opcode, params)
    return unless @enabled

    # reset memoized values
    @sorted_insts = nil
    @cur_index = nil
    @cur_pos = pos
    @instructions[pos] = Instruction.new(opcode, params)
    render
    # sleep 0.001
  end

  def render
    case @display_mode
    when :split
      render_split
    when :scroll
      render_scroll
    end
  end

  private

  def render_split
    nr_cols = (sorted_insts.size / @height) + 1
    col_width = 30 # @width / nr_cols

    sorted_insts.each_slice(@height).with_index do |insts, col|
      insts.each.with_index do |(pos, inst), line|
        @window.setpos(line, col * col_width)
        @window.addstr(render_inst(pos, inst, col_width))
      end
    end

    @window.refresh
  end

  def render_scroll
    instructions_to_render.each.with_index do |(pos, inst), line|
      @window.setpos(line, 0)
      @window.addstr(render_inst(pos, inst, @width - 2))
    end
    @window.refresh
  end

  def render_inst(pos, inst, width)
    str = "#{@cur_pos == pos ? '>' : ' '}#{'%3d' % pos} #{inst.to_s}"
    "%-#{width}.#{width}s" % str
  end

  def sorted_insts
    @sorted_insts ||= @instructions.sort_by { |pos, _| pos }
  end

  def cur_index
    @cur_index ||= sorted_insts.find_index { |pos, _| pos == @cur_pos }
  end

  def instructions_to_render
    # do all instructions fit in the viewport?
    return sorted_insts if sorted_insts.size <= @height

    # do we need to shift the current viewport?
    unless cur_index >= @viewport_shift && cur_index <= (@height + @viewport_shift)
      @viewport_shift = (cur_index - @height / 2)
    end

    sorted_insts[@viewport_shift, @height]
  end
end
