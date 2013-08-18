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
      process(sexp.rest)
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

    def process_func_body(sexp)
      return_val = catch(:return) {
        sexp.rest.each do |sub_sexp|
          process sub_sexp
        end
      }
      return_val
    end

    def process_func_decl(sexp)
      name = sexp[1]
      @stack[name] = extract_function_from(sexp)
    end

    def process_empty(sexp)
      nil
    end

    def process_return(sexp)
      throw :return, process(sexp[1])
    end

    private

    def extract_function_from(sexp)
      arg_names = sexp[2].map(&:last)
      [arg_names, sexp[3]]
    end
  end
end
