module MRubyPlc
class IREP
  attr_accessor :id, :nregs, :nlocals, :pools, :syms, :reps, :iseq
  attr_reader :locals, :codes

  def initialize
    @locals = {}
    @codes = []
  end

end
end
