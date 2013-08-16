require 'sexp_processor'
require 'rkelly'

module RubyScript
  class Interpreter < SexpInterpreter
    attr_reader :parser

    def initialize
      super
      @stack = {} # Hackity hackity hackity hack!
      @parser = RKelly::Parser.new
    end

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

    def process_expression(sexp)
      car, *cdr = *sexp
      process(cdr.flatten(1))
    end

    def process_lit(sexp)
      sexp.last
    end

    def process_str(sexp)
      str = sexp.last
      quote = str[0]
      str[1, str.length - 2].gsub(/\\#{quote}/, quote)
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

      cond_result = process(cond)

      unless [false, 0, Float::NAN, nil, ""].include?(cond_result)
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
        @stack[res]
      end
    end

    def process_nil(sexp)
      nil
    end

    def process_op_equal(sexp)
      resolve_sexp = sexp[1]
      raise ArgumentError, "We don't know what's happening in this assignment: #{ sexp.inspect }" unless resolve_sexp[0] == :resolve
      assign_to = resolve_sexp[1]
      value = process(sexp[2])
      @stack[assign_to] = value
    end

    def process_func_expr(sexp)
      fun = [sexp[2], sexp[3]]
      fun
    end

    def process_function_call(sexp)
      function_called = process sexp[1]
      process function_called[1]
    end

    def process_func_body(sexp)
      ret_val = nil
      sexp[1].each do |sub_sexp|
        if sub_sexp[0] == :return
          ret_val = process sub_sexp[1]
          break
        else
          process sub_sexp
        end
      end
      ret_val
    end

    def process_func_decl(sexp)
      name = sexp[1]
      fun = [sexp[2], sexp[3]]
      @stack[name] = fun
      fun
    end

    def process_empty(sexp)
      nil
    end
  end
end
