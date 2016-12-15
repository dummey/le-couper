require 'syro'

# Path to project components
GLOB = "./{lib,decks,routes,models,filters,services}/*.rb"
# Load components
Dir[GLOB].each { |file| require file }

# Create thin web layer
Web = Syro.new(AnagramsREST) do
  get do
    res.write "hello, world"
  end
end

# Rack it up
App = Rack::Builder.new do
  run(Web)
end