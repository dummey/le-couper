require "minitest/autorun"
require_relative "../service/anagrams"

DEFAULT_WORD_LIST = ["cat", "act", "dog", "God", "read", "dear", "dare"]

class TestServiceAnagram < Minitest::Test

  def _setup
    Anagrams.new.add_words(DEFAULT_WORD_LIST)
  end

  def test_create_anagrams
    anagrams = self._setup

    assert_equal DEFAULT_WORD_LIST.count, anagrams.words.count
  end

  def test_adding_additional_words
    additional_words = [""]
    anagrams = self._setup

    anagrams.add_words(additional_words)

    assert_equal DEFAULT_WORD_LIST.count + additional_words.count, anagrams.words.count
  end

  def test_find_anagrams
    anagrams = self._setup

    assert_equal ["God", "dog"], anagrams.find_anagram_from("dog")
    assert_equal ["act", "cat"], anagrams.find_anagram_from("tac")
  end

  def test_find_anagram_with_limit
    anagrams = self._setup
    expected_results = ["dare", "dear", "read"]

    assert_equal expected_results[0..0], anagrams.find_anagram_from("read", limit: 1)
    assert_equal expected_results[0..1], anagrams.find_anagram_from("read", limit: 2)
    assert_equal expected_results, anagrams.find_anagram_from("read", limit: 3)
    assert_equal expected_results, anagrams.find_anagram_from("read", limit: 10)
    assert_equal [], anagrams.find_anagram_from("read", limit: -10)
    # assert_raises "comparison of String with 1", anagrams.find_anagram_from("read", limit: "10")
  end

  def test_find_anagram_with_pronouns
  def test_find_anagrams
    anagrams = self._setup

    assert_equal ["God", "dog"], anagrams.find_anagram_from("dog", exclude_pronouns: false)
    assert_equal ["dog"], anagrams.find_anagram_from("dog", exclude_pronouns: true)
  end
  end

  ## SAD CASES

  def test_find_empty
    anagrams = self._setup

    assert_equal [], anagrams.find_anagram_from("")
  end

  def test_find_too_big
    anagrams = self._setup

    silly_word = "a" * 100000

    assert_equal [], anagrams.find_anagram_from(silly_word)
  end
end