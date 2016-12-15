class Anagrams
  def initialize()
    # defaults the value for new hash entrties as an empty array
    @anagrams = Hash.new { |h, k| h[k] = [] }

    self
  end

  def words 
    @anagrams.values.flatten
  end

  def sorted_words 
    @anagrams.keys
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

    sorted_word = word.chars.sort.join

    @anagrams[sorted_word] << word
  end
end