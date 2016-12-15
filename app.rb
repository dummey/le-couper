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

  post do 

  end

  delete do 

  end
end

# Rack it up
App = Rack::Builder.new do
  run(Web)
end