require 'syro'

# Path to project components
GLOB = "./{lib,decks,routes,models,filters,services}/*.rb"
# Load components
Dir[GLOB].each { |file| require file }

# Create thin web layer
Web = Syro.new(AnagramsREST) do
  on "anagrams" do 
    on :word do 
      get do
        word = index["word"]
        res.write AnagramsREST.find_word(word)
      end
    end
  end

  on "words.json" do 
    post do 
      req.params
      res.write inbox
    end

    delete do 
      res.write "delete all"
    end
  end

  on "words" do 
    on :word do
      delete do 
        res.write "delete"
      end
    end
  end
end

# Rack it up
App = Rack::Builder.new do
  run(Web)
end