require "minitest/autorun"
require_relative "../app.rb"

require "rack/test"
class Driver
  include Rack::Test::Methods

  def initialize(app)
    @app = app
  end

  def app
    @app
  end
end

class TestServer < Minitest::Test
  def setup
    @server = Driver.new(App)
    @server.post("/words.json", {"words" => ["read", "dear", "dare"] }.to_json)
  end

  def teardown
    @server.delete("/words.json")
  end

  def test_GET_anagrams_happy
    word = "read"

    @server.get("/anagrams/#{word}.json") do |res|
      assert_equal 200, res.status, 'GET endpoint exists'
      assert_equal ["dare", "dear"], JSON.parse(res.body)["anagrams"], "Checking anagram lookup result"
    end

    @server.get("/anagrams/#{word}.json?limit=1") do |res|
      assert_equal 200, res.status, 'GET endpoint exists'
      assert_equal ["dare"], JSON.parse(res.body)["anagrams"], "Checking anagram lookup result"
    end
  end

  def test_GET_anagrams_sad
    [
      "/anagrams/.json",
      "/anagrams/foo.xml",
      "/anagrams/foo",
      "/anagrams/foo."
    ].each do |path|
      @server.get(path) do |res|
        assert_equal 400, res.status, 'GET endpoint exists'
      end
    end
  end

  def test_add_additional_words
    @server.post("/words.json", {"words" => ["bat", "tab"]}.to_json)

    @server.get("/anagrams/tab.json") do |res|
      assert_equal ["bat"], JSON.parse(res.body)["anagrams"]
    end 
  end

  def test_add_additional_words_sad
    @server.post("/words.json", {"huh" => "thing"}.to_json) do |res|
      assert_equal 400, res.status
    end
  end

  def test_delete_single_word
    @server.delete("/words/dare.json") do |res|
      assert_equal 200, res.status
    end

    @server.get("/anagrams/dear.json") do |res|
      assert_equal 200, res.status, 'GET endpoint exists'
      assert_equal ["read"], JSON.parse(res.body)["anagrams"]
    end
  end

  def test_delete_word_and_anagrams

  end

  def test_delete_all
    @server.delete("/words.json") do |res|
      assert_equal 204, res.status
    end

  end
end