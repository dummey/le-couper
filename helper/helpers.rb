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
end