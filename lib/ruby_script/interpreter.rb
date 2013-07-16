require 'sexp_processor'
require 'rkelly'

module RubyScript
  class Interpreter < SexpInterpreter
    attr_reader :parser

    def initialize
      super
      @parser = RKelly::Parser.new
    end
  end
end
