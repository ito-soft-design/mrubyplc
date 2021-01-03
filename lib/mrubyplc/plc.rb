module MRubyPlc

class PLC

  attr_reader :ireps
  attr_reader :dr_ptr, :di_ptr, :dc_ptr, :dg_ptr
  attr_reader :ss_ptr

  SIZE_OF_MRB_VALUE = 3

  def initialize
    @ireps = []
    @dr_ptr = 0
    @di_ptr = 0
    @dc_ptr = 0
    @dg_ptr = 0
    @ss_ptr = 0
  end

  def reserve_regs nreg
    @dr_ptr.tap do |ptr|
      @dr_ptr += SIZE_OF_MRB_VALUE * nreg
    end
  end

  def assign_reg_for ptr, reg
    index = reg.match(/\d+/).values_at(0).first.to_i - 1
    "DR#{ptr + SIZE_OF_MRB_VALUE * index}"
  end

  def assign_ivar
    d = "DI#{@di_ptr}"
    @di_ptr += SIZE_OF_MRB_VALUE
    d
  end

  def assign_cvar
    d = "DC#{@dc_ptr}"
    @dc_ptr += SIZE_OF_MRB_VALUE
    d
  end

  def assign_gvar
    d = "DG#{@dg_ptr}"
    @dg_ptr += SIZE_OF_MRB_VALUE
    d
  end

  def assign_ssvar
    d = "SS#{@ss_ptr}"
    @ss_ptr += 1
    d
  end


end

end