require "minitest/autorun"
require_relative "../decks/anagrams_adapter"

DEFAULT_WORD_LIST ||= ["cat", "act", "dog", "God", "read", "dear", "dare"]

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
     AnagramsAdapter.find_anagrams_for("cat")
   end
  end

  def test_find_anagrams
    assert_equal ["act"], AnagramsAdapter.find_anagrams_for("cat")

    assert_equal ["dare"], AnagramsAdapter.find_anagrams_for("read", limit: 1)

    assert_equal [], AnagramsAdapter.find_anagrams_for("dog", exclude_pronouns: true)    
  end

  def test_delete_word
    AnagramsAdapter.delete_word("act")

    assert_equal [], AnagramsAdapter.find_anagrams_for("cat")
  end

  def test_delete_word_and_anagrams
    AnagramsAdapter.delete_word_and_anagrams("read")

    assert_equal [], AnagramsAdapter.find_anagrams_for("dear")
  end

  def test_delete_all
    AnagramsAdapter.delete_all

    assert_equal [], AnagramsAdapter.find_anagrams_for("cat")
  end

  def test_stats
    expected = {:word_count=>7, :min=>3, :max=>4, :average=>3.4285714285714284, :median=>3}
    assert_equal expected, AnagramsAdapter.stats
  end

  def test_assert_are_anagrams
    assert_equal true, AnagramsAdapter.assert_are_anagrams("dare", "dear")
    assert_equal false, AnagramsAdapter.assert_are_anagrams("dare", "cat")
    assert_equal false, AnagramsAdapter.assert_are_anagrams("not_a_word", "dear")
  end

end