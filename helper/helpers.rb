module Helpers
  def self.symbolize_keys(hash)
    Hash[hash.map{ |k, v| [k.to_sym, v] }]
  end
end