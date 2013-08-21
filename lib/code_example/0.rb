# interpreter.rb
require 'sexp_processor'
require 'rkelly'

class Interpreter < SexpInterpreter
  attr_reader :parser

  def initialize
    super
    @stack = {} # hacky hacky hacky hack!
    @parser = RKelly::Parser.new
  end

  def eval(source)
  end
end

# interpreter_test.rb
require 'test_helper'
class RubyScriptTest < Minitest::Test
end
