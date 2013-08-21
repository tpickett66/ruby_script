module RubyScript
  class Interpreter < SexpInterpreter

    # ... omitted ...
    def eval(source)
      ast = parser.parse(source)
      raise "Unable to parse JS: #{ source }" if ast.nil?
      sexps = ast.to_sexp
      result = ''
      sexps.each do |expression|
        result = process(expression)
      end
      result
    end
  end
end
