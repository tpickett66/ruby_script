require 'test_helper'

module RubyScript
  class InterpreterTest < Minitest::Unit::TestCase
    attr_accessor :int

    def setup
      self.int = Interpreter.new
    end

    def test_sanity
      assert_eval 3, '3'
      assert_eval 9, '6 + 3;'
    end

    def test_true
      assert_eval true, 'true'
    end

    def test_if
      assert_eval 42, 'if (true) { 42 } else { 24 }'
    end

    def test_if_falsey
      assert_eval 24, 'if ( false ) { 42 } else { 24 }'
      assert_eval 24, 'if ( 0 ) { 42 } else { 24 }', "Expected 0 to be falsey but wasn't"
      assert_eval 24, 'if ( NaN ) { 42 } else { 24 }', "Expected NaN to be falsey but wasn't"
      assert_eval 24, 'if ( undefined ) { 42 } else { 24 }', "Expected undefined to be falsey but wasn't"
      assert_eval 24, 'if ( null ) { 42 } else { 24 }', "Expected null to be falsey but wasn't"
      assert_eval 24, 'if ( "" ) { 42 } else { 24 }', "Expected empty string to be falsey"
    end

    private

    def assert_eval(expression, source, message = nil)
      assert_equal expression, int.eval(source), message
    end
  end
end
