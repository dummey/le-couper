require "minitest/autorun"
require_relative "../app.rb"

class TestServer < Minitest::Test
  def setup
    @server = App
  end

  def test_endpoints
    expected = [200, {"Content-Length"=>"12", "Content-Type"=>"text/html"}, ["hello, world"]]
    params = {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO"      => "/",
    }

    assert_equal expected, @server.call(params)
  end
end