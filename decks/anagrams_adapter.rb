require 'syro'
require_relative '../service/anagrams'

# Guideline: Return an empty array when possible for sad cases
class AnagramsAdapter < Syro::Deck
  def self._ensure_anagrams
    unless @anagrams
      raise "Need to add words before we can make anagram magic."
    end
  end

  def self.add_words(word_list)
    @anagrams ||= Anagrams.new

    @anagrams.add_words(word_list)

    self
  end

  def self.find_anagram_for(word, options = {})
    self._ensure_anagrams

    @anagrams.find_anagram_for(word, options)
  end

  def self.delete_all
    @anagrams = Anagrams.new
  end

  def self.delete_word(word)
    self._ensure_anagrams
    
    @anagrams.delete_word(word)

    self
  end

  def self.delete_word_and_anagrams(word)
    self._ensure_anagrams

    @anagrams.delete_word_and_anagrams(word)
  end

  def self.count
    @anagrams.words.count
  end
end

__END__

Q: How should operations before a Anagram is created be handled? 
A: Throw an exception, API layers should be explicit. 