require "test_helper"
include MRubyPlc

class LoaderTest < Test::Unit::TestCase

  def test_load_prg_001
    irep = load 'test/files/prg_001.rb'
    #assert_equal irep.id, "0x7fc23d606790"
    assert_equal irep.nregs, 3
    assert_equal irep.nlocals, 2
    assert_equal irep.pools, 0
    assert_equal irep.reps, 0
    assert_equal irep.iseq, 8

    assert_equal "R1", irep.locals.first.reg
    assert_equal "a", irep.locals.first.name

    code = irep.codes[0]
    assert_equal 1, code.no
    assert_equal 0, code.address
    assert_equal "OP_LOADI_1", code.opecode
    assert_equal ["R2"], code.operands

    code = irep.codes[1]
    assert_equal 1, code.no
    assert_equal 2, code.address
    assert_equal "OP_MOVE", code.opecode
    assert_equal ["R1", "R2"], code.operands
    assert_equal ["R1:a"], code.comments
  end

  def test_load_prg_002
    irep = load 'test/files/prg_002.rb'
    #assert_equal irep.id, "0x7fc23d606790"
    assert_equal irep.nregs, 8
    assert_equal irep.nlocals, 7
    assert_equal irep.pools, 2
    assert_equal irep.syms, 4
    assert_equal irep.reps, 0
    assert_equal irep.iseq, 39

    irep.variables[1].tap do |v|
      assert_equal :local, v.var_type
      assert_equal "R1", v.reg
      assert_equal "a", v.name
      assert_equal :integer, v.val_type
      assert_equal 10, v.base
      assert_equal 1, v.value
    end
    irep.variables[2].tap do |v|
      assert_equal :local, v.var_type
      assert_equal "R2", v.reg
      assert_equal "b", v.name
      assert_equal :boolean, v.val_type
      assert_equal true, v.value
    end
    irep.variables[3].tap do |v|
      assert_equal :local, v.var_type
      assert_equal "R3", v.reg
      assert_equal "c", v.name
      assert_equal :float, v.val_type
      assert_equal 1.23, v.value
    end
    irep.variables[4].tap do |v|
      assert_equal :local, v.var_type
      assert_equal "R4", v.reg
      assert_equal "d", v.name
      assert_equal :string, v.val_type
      assert_equal "abc", v.value
      assert_equal 3, v.size
    end
    irep.variables[5].tap do |v|
      assert_equal :local, v.var_type
      assert_equal "e", v.name
    end
    irep.variables[6].tap do |v|
      assert_equal :instance, v.var_type
      assert_equal "@f", v.name
    end
    irep.variables[7].tap do |v|
      assert_equal :class, v.var_type
      assert_equal "@@f", v.name
    end
    irep.variables[8].tap do |v|
      assert_equal :global, v.var_type
      assert_equal "$g", v.name
    end
    irep.variables[9].tap do |v|
      assert_equal :local, v.var_type
      assert_equal "R6", v.reg
      assert_equal "a0", v.name
      assert_equal :integer, v.val_type
      assert_equal 10, v.base
      assert_equal 1, v.value
    end

    irep.codes.first.tap do |code|
      assert_equal 1, code.no
      assert_equal 0, code.address
      assert_equal "OP_LOADI_1", code.opecode
      assert_equal ["R1"], code.operands
    end

    irep.codes[-2].tap do |code|
      assert_equal 9, code.no
      assert_equal 38, code.address
      assert_equal "OP_STOP", code.opecode
    end

  end


end