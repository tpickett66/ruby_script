# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'haml', :output => '.', :input => 'lib', :haml_options => { :ugly => true } do
  watch %r{^lib/.+(\.html\.haml)}
end

guard 'sass', :input => 'lib/css', :output => 'css'

guard :minitest do
  # with Minitest::Unit
  watch(%r{^test/(.*)\/?(.*)_test\.rb})
  watch(%r{^lib/(.*/)?([^/]+)\.(?:rb|tt)})     { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/test_helper\.rb})      { 'test' }
end
