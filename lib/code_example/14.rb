module RubyScript
  class Interpreter < SexpInterpreter
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
  end
end
