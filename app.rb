require 'syro'
require 'json'
require 'cgi'

# Path to project components
GLOB = "./{helper,decks,services}/*.rb"
# Load components
Dir[GLOB].each { |file| require file }

# Create thin web layer
Web = Syro.new(AnagramsAdapter) do
  on "anagrams" do 
    on :word do 
      get do
        path_word = inbox[:word]
        (word, format) = Helpers.parse_path_word(path_word)
        word = Helpers.sanitize_word(word)

        # parse options
        options = CGI::parse(req.query_string)
        options = Helpers.symbolize_keys(options)

        # TODO: Find helpers to make this cleaner
        if options[:limit]
          options[:limit] = options[:limit][0].to_i
        end

        if options[:exclude_pronouns]
          options[:exclude_pronouns] = options[:exclude_pronouns][0] == 'true'
        end

        if word && format && format.casecmp("json") == 0
          res.status = 200
          res.write(
            {"anagrams" => AnagramsAdapter.find_anagrams_for(word, options)}.to_json
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
        word_list = Helpers.sanitize_word_list(word_list) 
        AnagramsAdapter.add_words(word_list)
        res.status = 201
        res.write "Added #{word_list} to anagram database"
      else
        res.status = 400
        res.write("Please provide word list in the json format of `{ 'word' => [] }`")
      end
    end

    delete do 
      AnagramsAdapter.delete_all
      res.status = 204
    end
  end

  on "words" do 
    on :word do
      delete do 
        path_word = inbox[:word]
        (word, _) = Helpers.parse_path_word(path_word)
        word = Helpers.sanitize_word(word)

        # Ignore the format?

        # Check for delete_anagrams
        options = CGI::parse(req.query_string)
        options = Helpers.symbolize_keys(options)

        if options[:delete_anagrams] && options[:delete_anagrams][0] == 'true'
          AnagramsAdapter.delete_word_and_anagrams(word)
        else
          AnagramsAdapter.delete_word(word)
        end
        res.write "#{word} has been deleted."
      end
    end
  end

  on "stats.json" do 
    res.write AnagramsAdapter.stats.to_json
  end
end

# Rack it up
App = Rack::Builder.new do
  run(Web)
end