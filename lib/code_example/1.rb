# interpreter_test.rb
require 'test_helper'
class RubyScriptTest < Minitest::Test
  attr_accessor :int

  def setup
    self.int = Interpreter.new
  end

  def test_sanity
    assert_eval 3, '3'
    assert_eval 9, '6 + 3;'
  end

  private

  def assert_eval(expression, source, message = nil)
    assert_equal expression, int.eval(source), message
  end
end
