require 'sexp_processor'
require 'rkelly'

module RubyScript
  class Interpreter < SexpInterpreter
    attr_reader :parser

    def initialize
      super
      @parser = RKelly::Parser.new
    end

    def eval(source)
      ast = parser.parse(source)
      sexps = ast.to_sexp[0]
      process(sexps)
    end

    def process_expression(sexp)
      car, *cdr = *sexp
      process(cdr.flatten(1))
    end

    def process_lit(sexp)
      sexp.last
    end

    def process_add(sexp)
      _, *args = sexp
      args.map{|lit| process(lit) }.reduce(0){|a, v| a + v}
    end

    def process_true(sexp)
      true
    end

    def process_false(sexp)
      false
    end

    def process_if(sexp)
      _, cond, t, f = sexp

      if process(cond)
        process(t)
      else
        process(f)
      end
    end

    def process_block(sexp)
      _, exp = sexp
      process(exp[0])
    end

    def process_resolve(sexp)
      _, res = sexp

      case res
      when "NaN"
        Float::NAN
      when "undefined"
        nil
      else
        raise "Unknown symbol to resolve: #{ res }, sexp: #{ sexp.inspect }"
      end
    end
  end
end
