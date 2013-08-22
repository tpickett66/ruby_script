  # from above....
  def process_resolve(sexp)
    _, res = sexp
    case res
    when "NaN"
      Float::NAN
    when "undefined"
      nil
    else
      raise 'oh, noes'
    end
  end

  def process_nil(sexp)
    nil
  end
end
