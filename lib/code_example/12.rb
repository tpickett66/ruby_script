module RubyScript
  class InterpreterTest < Minitest::Unit::TestCase
    def test_argless_function
      assert_eval 42, 'myFun = function () { return 42; }; myFun()'
      assert_eval 42, 'function myFun() { return 42; }; myFun()'
    end

    def test_function_with_args
      assert_eval 42, 'foo = function(bar) { return bar; }; foo(42);'
    end
  end
end
