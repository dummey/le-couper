class Anagrams
  def initialize()
    # defaults the value for new hash entrties as an empty array
    @anagrams = Hash.new { |h, k| h[k] = [] }
    @max_length = 0
    self
  end

  def words 
    @anagrams.values.flatten
  end

  def sorted_words 
    @anagrams.keys
  end

  def _update_max_legth(word)
    @max_length = word.length > @max_length ? word.length : @max_length
  end

  def max_length
    @max_length
  end

  def _sort_word(word)
    word.chars.sort.join
  end

  def add_words(word_list)
    word_list.each do |word|
      self.add_word(word)
    end

    self
  end

  def add_word(word)
    # Forcing all characters into lower case. 
    word = word.downcase
    sorted_word = _sort_word(word)

    self._update_max_legth(word)

    @anagrams[sorted_word] << word
    # Sorting each insert to help with determinism independent of insert order
    @anagrams[sorted_word].sort!
  end

  def find_anagram_from(word, limit = nil)
    return [] if word.length > @max_length
    return [] if limit && limit < 1

    results = @anagrams[_sort_word(word)]
    if limit
      # Being fancy here and using the array wrap around for limits
      results[0..limit-1]
    else
      results
    end
  end


end