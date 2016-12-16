Expermenting with using Syco(https://github.com/soveran/syro). 

The excercise is divided into 3 distinct parts.

1. `app.rb` is the entry into the program and handles parsing the URL and payload for hand off to the AnagramAdapter. 
2. `decks/anagrams_adapter` is responsible for providing a generic layer for accomplishing anagram lookup without exposing the underlying data structure. 
3. `service/anagrams.rb` is the sole mutable object and handles the processing of words along with storing and retrieving anagrams. 

## Running

`rake vendor_test` to run vendor tests.

`rake test` to run tests. 

`rake server` to start server.