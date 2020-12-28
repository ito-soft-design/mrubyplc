module MRubyPlc

class PLC

  attr_reader :ireps
  attr_reader :word_ptr

  SIZE_OF_MRB_VALUE = 3

  def initialize
    @ireps = []
    @bits = []
    @words = []
    @word_ptr = 0
  end

  def assign_regs nreg
    @word_ptr.tap do |ptr|
      @word_ptr += SIZE_OF_MRB_VALUE * nreg
    end
  end

  def reg_device_for ptr, reg
    index = reg.match(/\d+/).values_at(0).first.to_i - 1
    "DR#{ptr + SIZE_OF_MRB_VALUE * index}"
  end


end

end