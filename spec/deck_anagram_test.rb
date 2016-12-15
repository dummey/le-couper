require "minitest/autorun"
require_relative "../decks/anagrams_rest"

DEFAULT_WORD_LIST = ["cat", "act", "dog", "God", "read", "dear", "dare"]

class TestDeckAnagram < Minitest::Test

  def setup
    AnagramsREST.add_words(DEFAULT_WORD_LIST)
  end

  def teardown
    AnagramsREST.instance_variable_set(:@anagrams, nil)
  end

  def test_empty_deck
    AnagramsREST.instance_variable_set(:@anagrams, nil) 
    assert_raises RuntimeError do
     AnagramsREST.find_anagram_for("cat")
   end
  end

  def test_anagrams
    assert_equal ["act", "cat"], AnagramsREST.find_anagram_for("cat")
  end

end