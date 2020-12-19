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

    assert_equal "R1", irep.locals.first[:register]
    assert_equal "a", irep.locals.first[:name]

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
    assert_equal irep.nregs, 7
    assert_equal irep.nlocals, 6
    assert_equal irep.pools, 2
    assert_equal irep.syms, 4
    assert_equal irep.reps, 0
    assert_equal irep.iseq, 34

    irep.variables[1].tap do |v|
      assert_equal :local, v[:variable_type]
      assert_equal "R1", v[:register]
      assert_equal "a", v[:name]
      assert_equal :integer, v[:value_type]
      assert_equal 10, v[:base]
      assert_equal 1, v[:value]
    end
    irep.variables[2].tap do |v|
      assert_equal :local, v[:variable_type]
      assert_equal "R2", v[:register]
      assert_equal "b", v[:name]
    end
    irep.variables[3].tap do |v|
      assert_equal :local, v[:variable_type]
      assert_equal "R3", v[:register]
      assert_equal "c", v[:name]
    end
    irep.variables[4].tap do |v|
      assert_equal :local, v[:variable_type]
      assert_equal "R4", v[:register]
      assert_equal "d", v[:name]
    end
    irep.variables[5].tap do |v|
      assert_equal :local, v[:variable_type]
      assert_equal "e", v[:name]
    end
    irep.variables[6].tap do |v|
      assert_equal :instance, v[:variable_type]
      assert_equal "@f", v[:name]
    end
    irep.variables[7].tap do |v|
      assert_equal :class, v[:variable_type]
      assert_equal "@@f", v[:name]
    end
    irep.variables[8].tap do |v|
      assert_equal :global, v[:variable_type]
      assert_equal "$g", v[:name]
    end

    irep.codes[0].tap do |code|
      assert_equal 1, code.no
      assert_equal 0, code.address
      assert_equal "OP_LOADI_1", code.opecode
      assert_equal ["R1"], code.operands
    end

    irep.codes[12].tap do |code|
      assert_equal 8, code.no
      assert_equal 33, code.address
      assert_equal "OP_STOP", code.opecode
    end

  end


end