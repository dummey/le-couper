module Helpers
  def self.symbolize_keys(hash)
    Hash[hash.map{ |k, v| [k.to_sym, v] }]
  end

  def self.parse_path_word(word)
    # validate keyword
    word =~ /(\w+)\.(\w+)/

    word = $1
    format = $2

    [word, format]
  end

  def self.sanitize_word_list(word_list)
    word_list.map { |w| w.to_s }
  end

  def self.sanitize_word(word)
    word.to_s
  end
end