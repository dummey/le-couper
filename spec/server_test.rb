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

  # def test_endpoint_POST
  #   body = {"words" => ["read", "dear", "dare"] }

  #   @server.post("/words.json", body) do |res|
  #     assert_equal 200, res.status, 'POST endpoint exists'
  #   end
  # end

  # def test_endpoint_DELETE_single
  #   word = "sad"
    
  #   @server.delete("/words/#{word}.json") do |res|
  #     assert_equal 200, res.status, 'DELETE single endpoint exists'
  #   end
  # end

  # def test_endpoint_DELETE_all
  #   @server.delete("/words.json") do |res|
  #     assert_equal 200, res.status, "DELETE all endpoint exists"
  #   end
  # end
end