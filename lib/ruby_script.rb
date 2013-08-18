require_relative 'ruby_script/version'
require_relative 'ruby_script/interpreter'

module RubyScript

end

class Array
  def head
    self[0]
  end

  def rest
    rest = self[1..-1]
    rest.first === Symbol ? rest : rest.flatten(1)
  end
end
