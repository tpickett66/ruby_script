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

    private

    def assert_eval(expression, source, message = nil)
      assert_equal expression, int.eval(source), message
    end
  end
end
