require "test_helper"
include MRubyPlc

class VmWithPrg001Test < Test::Unit::TestCase

  def setup
    @irep = load 'test/files/prg_001.rb'
    @vm = VirtualMachine.new @irep
  end

  # def teardown
  # end

  def test_assign_memory
    @vm.assign_memory
    assert_equal 1, @vm.regs.size
    r = @vm.regs.values.first
    assert_equal ["R1", "a", "DR0"], [r.reg_name, r.var_name, r.device] 
  end

end

class VmWithPrg002Test < Test::Unit::TestCase

  def setup
    @irep = load 'test/files/prg_002.rb'
    @vm = VirtualMachine.new @irep
    @vm.assign_memory
  end

  # def teardown
  # end

  def test_local_variables
    assert_equal 5, @vm.regs.size
    r = @vm.regs.values[0]
    assert_equal ["R1", "a", "DR0"], [r.reg_name, r.var_name, r.device] 
    r = @vm.regs.values[1]
    assert_equal ["R2", "b", "DR3"], [r.reg_name, r.var_name, r.device] 
    r = @vm.regs.values[2]
    assert_equal ["R3", "c", "DR6"], [r.reg_name, r.var_name, r.device] 
    r = @vm.regs.values[3]
    assert_equal ["R4", "d", "DR9"], [r.reg_name, r.var_name, r.device] 
    r = @vm.regs.values[4]
    assert_equal ["R5", "e", "DR12"], [r.reg_name, r.var_name, r.device] 
  end

  def test_instance_variables_of_assign_memory
    assert_equal 1, @vm.ivars.size
    v = @vm.ivars.values[0]
    assert_equal ["@f", "DI0"], [v.var_name, v.device] 
  end

  def test_global_variables_of_assign_memory
    assert_equal 1, @vm.gvars.size
    v = @vm.gvars.values[0]
    assert_equal ["$h", "DG0"], [v.var_name, v.device] 
  end

end
