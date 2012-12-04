# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
	watch(%r{^spec/.+_spec\.rb$})
	watch(%r{^lib/(.+)\.rb$})     { |m| puts m; "spec/#{m[1]}_spec.rb" }
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch(%r{features/support/}) { :cucumber }
end
