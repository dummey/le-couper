require "minitest/autorun"
require_relative "../service/anagrams"
require_relative "../service/anagrams_plus"

DEFAULT_WORD_LIST = ["cat", "act", "dog", "God", "read", "dear", "dare"]

class TestServiceAnagram < Minitest::Test

  def _setup
    Anagrams.new.add_words(DEFAULT_WORD_LIST)
  end

  def test_anagram_stats
    anagrams = self._setup

    expected = {
      :word_count=>7, 
      :min=>3, 
      :max=>4, 
      :average=>3.4285714285714284, 
      :median=>3
    }

    assert_equal expected, AnagramsPlus.stats(anagrams.words)
  end
end