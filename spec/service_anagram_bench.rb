require 'benchmark'
require_relative "../service/anagrams"

Benchmark.bm do |x|
  x.report do
    path = File.expand_path("../dictionary.txt", __FILE__)
    contents = File.readlines(path)

    Anagrams.new.add_words(contents)
  end
end