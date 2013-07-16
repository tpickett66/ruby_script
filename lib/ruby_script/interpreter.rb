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
  end
end
