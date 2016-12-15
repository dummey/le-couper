require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "spec/*_test.rb"
end

# task :default do |t|
#   ruby "server.rb"
# end

task :server do |t|
  system("rackup")
end