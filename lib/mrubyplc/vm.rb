module MRubyPlc

Regisger = Struct.new :name, :var_name, :device, :variable

class VirtualMachine

  attr_reader :irep, :plc
  attr_reader :regs_ptr
  attr_reader :regs

  def initialize irep
    @irep = irep
    @plc = PLC.new
    @regs = {}
  end

  def assign_memory
    @regs_ptr = plc.assign_regs irep.nregs
    irep.variables.each do |v|
      next unless v
      case v.var_type
      when :local
        d = plc.reg_device_for(@regs_ptr, v.reg)
        regs[v.reg] = Regisger.new(v.reg, v.name, d, v)
      end
    end
  end

end

end