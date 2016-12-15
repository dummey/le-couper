require "minitest/autorun"
require_relative "../decks/anagrams_adapter"

DEFAULT_WORD_LIST = ["cat", "act", "dog", "God", "read", "dear", "dare"]

class TestDeckAnagram < Minitest::Test

  def setup
    AnagramsAdapter.add_words(DEFAULT_WORD_LIST)
  end

  def teardown
    AnagramsAdapter.instance_variable_set(:@anagrams, nil)
  end

  def test_empty_deck
    AnagramsAdapter.instance_variable_set(:@anagrams, nil) 
    assert_raises RuntimeError do
     AnagramsAdapter.find_anagram_for("cat")
   end
  end

  def test_find_anagrams
    assert_equal ["act", "cat"], AnagramsAdapter.find_anagram_for("cat")
  end

  def test_delete_anagrams
    AnagramsAdapter.delete_word("act")

    assert_equal ["cat"], AnagramsAdapter.find_anagram_for("cat")
  end

  def test_delete_all_anagrams
    AnagramsAdapter.delete_all

    assert_raises RuntimeError do
      AnagramsAdapter.find_anagram_for("cat")
    end
  end

end