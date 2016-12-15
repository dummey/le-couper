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
    word.downcase.chars.sort.join
  end

  def add_words(word_list)
    word_list.each do |word|
      self.add_word(word)
    end

    self
  end

  def add_word(word)
    # Forcing all characters into lower case for anagram form.
    sorted_word = _sort_word(word)

    self._update_max_legth(word)

    @anagrams[sorted_word] << word
    # Sorting each insert to help with determinism independent of insert order
    @anagrams[sorted_word].sort!

    self
  end

  def find_anagram_for(word, options = {})
    # Security check to prevent overloading
    return [] if word.length > @max_length

    # Options
    limit = options[:limit]
    return [] if limit && limit < 1

    exclude_pronouns = options[:exclude_pronouns]

    results = @anagrams[_sort_word(word)]

    # Remove self from results
    results = results.reject {|w| w == word }

    # Process options
    if limit
      results = results[0..limit-1]
    end

    if exclude_pronouns
      results = results.reject {|w| w == w.capitalize}
    end

    results
  end

  def delete_word(word)
    sorted_word = self._sort_word(word)
    @anagrams[sorted_word].delete(word)

    self
  end

  def delete_word_and_anagrams(word)
    sorted_word = self._sort_word(word)
    @anagrams[sorted_word] = []

    self
  end
end