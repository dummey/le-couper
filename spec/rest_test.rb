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

class TestREST < Minitest::Test
  def setup
    @server = Driver.new(App)
    @server.post("/words.json", {"words" => ["read", "dear", "dare", "bat", "tab", "dog", "God"] }.to_json)
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

  def test_GET_anagram_no_pronouns

    @server.get("/anagrams/dog.json?exclude_pronouns=true") do |res|
      assert_equal 200, res.status, 'GET endpoint exists'
      assert_equal [], JSON.parse(res.body)["anagrams"]
    end

    @server.get("/anagrams/dog.json?exclude_pronouns=false") do |res|
      assert_equal 200, res.status, 'GET endpoint exists'
      assert_equal ["God"], JSON.parse(res.body)["anagrams"]
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
    @server.post("/words.json", {"words" => ["read", "dear", "dare", "bat", "tab"]}.to_json)

    # This actually also catches the problem of StringIO being passed in
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
      assert_equal 200, res.status
      assert_equal ["read"], JSON.parse(res.body)["anagrams"]
    end
  end

  def test_delete_word_and_anagrams
    @server.delete("/words/dare.json?delete_anagrams=true") do |res|
      assert_equal 200, res.status
    end

    @server.get("/anagrams/dear.json") do |res|
      assert_equal 200, res.status
      assert_equal [], JSON.parse(res.body)["anagrams"]
    end

    @server.get("/anagrams/bat.json") do |res|
      assert_equal 200, res.status
      assert_equal ["tab"], JSON.parse(res.body)["anagrams"]
    end
  end

  def test_delete_all
    @server.delete("/words.json") do |res|
      assert_equal 204, res.status
    end
  end

  def test_stats
    @server.get("/stats.json") do |res|
      assert_equal 200, res.status

      expected = {"word_count"=>7, "min"=>3, "max"=>4, "average"=>3.4285714285714284, "median"=>3}

      assert_equal expected, JSON.parse(res.body)
    end
  end
end