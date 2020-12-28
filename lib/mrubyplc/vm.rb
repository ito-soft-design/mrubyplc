module MRubyPlc

PlcVariable = Struct.new :reg_name, :var_name, :device, :variable

class VirtualMachine

  attr_reader :irep, :plc
  attr_reader :regs_ptr
  attr_reader :regs, :ivars, :cvars, :gvars

  def initialize irep
    @irep = irep
    @plc = PLC.new
    @regs = {}
    @ivars = {}
    @cvars = {}
    @gvars = {}
  end

  def assign_memory
    @regs_ptr = plc.assign_regs irep.nregs
    irep.variables.each do |v|
      next unless v
      case v.var_type
      when :local
        d = plc.reg_device_for(@regs_ptr, v.reg)
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
  end

end

end