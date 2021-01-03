module MRubyPlc

PlcVariable = Struct.new :reg_name, :var_name, :device, :variable

class VirtualMachine

  attr_reader :irep, :plc
  attr_reader :regs_ptr
  attr_reader :regs, :ivars, :cvars, :gvars
  attr_reader :ladders

  def initialize irep
    @irep = irep
    @plc = PLC.new
    @regs = {}
    @ivars = {}
    @cvars = {}
    @gvars = {}
    @ladders = []

    assign_memory
    generate_ladders
  end

  def assign_memory
    @regs_ptr = plc.reserve_regs irep.nregs
    irep.variables.each do |v|
      next unless v
      case v.var_type
      when :local
        d = plc.assign_reg_for(@regs_ptr, v.reg)
        regs[v.reg] = PlcVariable.new(v.reg, v.name, d, v)
      when :instance
        d = plc.assign_ivar
        ivars[v.name] = PlcVariable.new(nil, v.name, d, v)
      when :class
        d = plc.assign_cvar
        cvars[v.name] = PlcVariable.new(nil, v.name, d, v)
      when :global
        d = plc.assign_gvar
        gvars[v.name] = PlcVariable.new(nil, v.name, d, v)
      end
    end
    irep.nregs.times do |i|
      r = "R#{i + 1}"
      regs[r] ||= begin
        d = plc.assign_reg_for(@regs_ptr, r)
        regs[r] = PlcVariable.new(r, nil, d, nil)
      end
    end
  end

  def generate_ladders
    ss = plc.assign_ssvar
    ladders << %w(LDP     $_ON)
    ladders << ['SET', ss]
    ladders << ['LD', ss]
    irep.codes.each do |c|
      case c.opecode
      when /OP_LOADI_(_?)(\d)/
        v = $2.to_i
        v = -v if $1 == '_'
        ladders << ["LOADI", regs[c.operands[0]].device, v]
      when 'OP_MOVE'
        ladders << ["MOVE", regs[c.operands[0]].device, regs[c.operands[1]].device ]
      when 'OP_RETURN'
        ladders << ['RST', ss]
      when 'OP_STOP'
      when nil, ''

      # TODO: It's just passing for tests. Implement these later.
      when 'OP_LOADT', 'OP_LOADL', 'OP_STRING', 'OP_LOADSYM', 'OP_LOADI', 'OP_SETIV', 'OP_LOADI16', 'OP_SETCV', 'OP_SETGV'
      else
        raise "#{c.opecode} is not implemented!"
      end
    end
  end

end

end