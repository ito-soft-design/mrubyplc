module MRubyPlc
class IREP
  attr_accessor :id, :no, :nregs, :nlocals, :pools, :syms, :reps, :iseq
  attr_reader :variables, :codes

  def initialize
    @variables = []
    @codes = []
  end

  def locals
    variables.select{|v| v && v[:variable_type] == :local }
  end

end
end
