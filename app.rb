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
        res.write inbox[:word]
      end
    end
  end

  on "words.json" do 
    post do 
      req.params
      res.write inbox
    end
  end

#/words/:word.json
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