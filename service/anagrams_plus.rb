module AnagramsPlus

  # returns a count of words in the corpus and min/max/median/average word length
  def self.stats(word_list)
    word_count = word_list.count

    min_word = word_list.min { |a,b| a.length <=> b.length }
    min = min_word.length

    max_word = word_list.max { |a,b| a.length <=> b.length }
    max = max_word.length

    word_lengths = word_list.map { |w| w.length }
    total = word_lengths.inject(:+)
    average = total.to_f / word_count.to_f

    sorted = word_lengths.sort
    mid = word_count / 2
    median = word_count.odd? ? sorted[mid / 2] : (sorted[mid / 2] + sorted[mid / 2 + 1] / 2.0)

    return {
      word_count: word_count,
      min: min,
      max: max,
      average: average,
      median: median,
    }
  end
end