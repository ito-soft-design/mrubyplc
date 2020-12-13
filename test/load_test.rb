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

    assert_equal "R1", irep.locals.first[0]
    assert_equal "a", irep.locals.first[1]

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



end