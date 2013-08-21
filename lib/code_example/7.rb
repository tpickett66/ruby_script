module RubyScript
  class Interpreter < SexpInterpreter

    def process_expression(sexp)
      process(sexp.rest)
    end

    def process_lit(sexp)
      sexp.last
    end

    def process_add(sexp)
      _, *args = sexp
      args.map{|lit| process(lit) }.reduce(0){|a, v| a + v}
    end
  end
end
