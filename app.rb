require 'syro'
require 'json'

# Path to project components
GLOB = "./{lib,decks,routes,models,filters,services}/*.rb"
# Load components
Dir[GLOB].each { |file| require file }

# Create thin web layer
Web = Syro.new(AnagramsAdapter) do
  on "anagrams" do 
    on :word do 
      get do
        word = inbox[:word]

        # validate keyword
        word =~ /(\w+)\.(\w+)/

        word = $1
        format = $2

        if word && format && format.casecmp("json") == 0
          res.write(
            {"anagrams" => AnagramsAdapter.find_anagram_for(word)}.to_json
          )
        else 
          res.status = 400
          res.write("Provided format is invalid, .json is supported")
        end
      end
    end
  end

  on "words.json" do 
    post do 
      body = JSON.parse(req.body.read)
      word_list = body["words"]

      if word_list
        AnagramsAdapter.add_words(word_list)
        res.write "Added #{word_list} to anagram database"
      else
        res.status = 400
        res.write("Please provide word list in the json format of `{ 'word' => [] }`")
      end

    end

    delete do 
      AnagramsAdapter.delete_all
      res.write "All entries have been deleted."
    end
  end

  on "words" do 
    on :word do
      delete do 
        word = inbox[:word]
        AnagramsAdapter.delete_word(word)
        res.write "#{word} has been deleted."
      end
    end
  end
end

# Rack it up
App = Rack::Builder.new do
  run(Web)
end