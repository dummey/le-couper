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
  end

  def test_endpoint_GET
    word = "happy"

    @server.get("/anagrams/#{word}.json") do |res|
      assert_equal 200, res.status, 'GET endpoint exists'
    end
    # assert_equal [word], res.body, 'GET recieved the correct word'
  end

  def test_endpoint_POST
    body = {"words" => ["read", "dear", "dare"] }

    @server.post("/words.json", body) do |res|
      assert_equal 200, res.status, 'POST endpoint exists'
    end
  end

  def test_endpoint_DELETE_single
    word = "sad"
    
    @server.delete("/words/#{word}.json") do |res|
      assert_equal 200, res.status, 'DELETE single endpoint exists'
    end
  end

  def test_endpoint_DELETE_all
    @server.delete("/words.json") do |res|
      assert_equal 200, res.status, "DELETE all endpoint exists"
    end
  end
end