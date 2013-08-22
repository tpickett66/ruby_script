class Interpreter < SexpInterpreter
  def process_str(sexp)
    str = sexp.last; quote = str[0]
    str[1, str.length - 2].gsub(/\\#{quote}/, quote)
  end

  def process_true(sexp); true; end
  def process_false(sexp); false; end

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
    process(exp.rest)
  end

  # continued ....
