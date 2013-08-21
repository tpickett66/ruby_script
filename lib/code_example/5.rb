module RubyScript
  class Interpreter < SexpInterpreter

    def process_expression(sexp)
      raise sexp.inspect
    end
  end
end
