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
    assert_equal ["R1", "a", "DR0"], [r.name, r.var_name, r.device] 
  end

end

class VmWithPrg002Test < Test::Unit::TestCase

  def setup
    @irep = load 'test/files/prg_002.rb'
    @vm = VirtualMachine.new @irep
  end

  # def teardown
  # end

  def test_assign_memory
    @vm.assign_memory
    assert_equal 5, @vm.regs.size
    r = @vm.regs.values[0]
    assert_equal ["R1", "a", "DR0"], [r.name, r.var_name, r.device] 
    r = @vm.regs.values[1]
    assert_equal ["R2", "b", "DR3"], [r.name, r.var_name, r.device] 
    r = @vm.regs.values[2]
    assert_equal ["R3", "c", "DR6"], [r.name, r.var_name, r.device] 
    r = @vm.regs.values[3]
    assert_equal ["R4", "d", "DR9"], [r.name, r.var_name, r.device] 
    r = @vm.regs.values[4]
    assert_equal ["R5", "e", "DR12"], [r.name, r.var_name, r.device] 
  end

end
