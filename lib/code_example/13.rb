module RubyScript
  class Interpreter < SexpInterpreter
    def process_func_expr(sexp)
      extract_function_from(sexp)
    end

    def process_function_call(sexp)
      function_called = process sexp[1]
      args = sexp[2].rest
      function_called[0].zip(args) {|name, value|
        @stack[name] = process(value)
      }
      process function_called[1]
    end
  end
end
