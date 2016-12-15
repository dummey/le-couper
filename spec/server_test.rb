require "minitest/autorun"
require_relative "../app.rb"

module ResponseHelper
  def self.get_status(r)
    r[0]
  end

  def self.get_header(r)

  end

  def self.get_content(r)
    r[2]
  end
end

class TestServer < Minitest::Test
  def setup
    @server = App
  end

  def test_endpoint_GET
    word = "happy"

    params = {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO"      => "/anagrams/#{word}.json",
      "QUERY_STRING"   => "",
    }

    res = @server.call(params)

    assert_equal 200, ResponseHelper.get_status(res), 'GET Endpoint exists'
    assert_equal [word], ResponseHelper.get_content(res), 'GET recieved the correct word'
  end

  def test_endpoint_POST
    params = {
      "REQUEST_METHOD" => "POST",
      "PATH_INFO"      => "/words.json",
      "QUERY_STRING"   => "",
    }

    assert_equal 200, ResponseHelper.get_status(@server.call(params)), 'POST Endpoint exists'
  end

  def test_endpoint_DELETE
    params = {
      "REQUEST_METHOD" => "DELETE",
      "PATH_INFO"      => "DELETE /words/:word.json",
      "QUERY_STRING"   => "",
    }

    assert_equal 200, ResponseHelper.get_status(@server.call(params)), 'DELETE Endpoint exists'
  end
end