require "minitest/autorun"
require_relative "../service/anagrams"

DEFAULT_WORD_LIST = ["cat", "act", "dog", "God", "read", "dear", "dare"]

class TestServiceAnagram < Minitest::Test
  def test_create_anagrams
    anagrams = Anagrams.new.add_words(DEFAULT_WORD_LIST)

    assert_equal DEFAULT_WORD_LIST.count, anagrams.words.count
  end

  def test_force_downcase
    anagrams = Anagrams.new.add_words(["DOG"])

    assert_equal ["dog"], anagrams.words
  end

  def test_adding_additional_words
    additional_words = [""]
    anagrams = Anagrams.new.add_words(DEFAULT_WORD_LIST)

    anagrams.add_words(additional_words)

    assert_equal DEFAULT_WORD_LIST.count + additional_words.count, anagrams.words.count
  end
end