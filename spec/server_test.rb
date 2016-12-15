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

    res = @server.get("/anagrams/#{word}.json")

    assert_equal 200, res.status, 'GET Endpoint exists'
    # assert_equal [word], res.body, 'GET recieved the correct word'
  end

  def test_endpoint_POST
    body = {"words" => ["read", "dear", "dare"] }

    res = @server.post("/words.json", body)

    assert_equal 200, res.status, 'POST Endpoint exists'
  end

  def test_endpoint_DELETE_single
    res = @server.delete("/words/:word.json")

    assert_equal 200, res.status, 'DELETE Endpoint exists'
  end

  def test_endpoint_DELETE_all

  end
end