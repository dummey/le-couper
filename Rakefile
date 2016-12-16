require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "spec/*_test.rb"
end

task :vendor_test do |t|
  # TODO: Add cleanup in case of midway crash
  p = IO.popen("rackup -p 3000")
  pid = p.pid

  sleep(1)

  ruby "vendor_spec/anagram_test.rb"

  Process.kill("INT", pid)
end

task :server do |t|
  system("rackup")
end