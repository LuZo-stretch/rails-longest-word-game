require 'net/http'

class GamesController < ApplicationController

  def new
    @letters = 10.times.map { ('A'..'Z').to_a.sample }
  end

  def score
    # 3. Set messages (score optional)
    @word = params[:word].upcase
    @letters_grid = params[:letters].split('')
    if valid_word?(@word, @letters_grid)
      if english_word?(@word)
        message = "Well done!"
      else
        message = "That's not an English word"
      end
    else
        message = "Sorry, but #{@word} can't be built from the given letters."
    end
    # 4. Use hidden fields to pass additional data (why?)
    @message = message
  end

  # 1. Check if the word can be built from the grid.
  def valid_word?(word, letters_grid)
    word.chars.all? {|char| word.count(char) <= letters_grid.count(char)}
  end

  # 2. Check if it is a real word in English -- use API
  def english_word?(word)
    uri = URI("https://wagon-dictionary.herokuapp.com/#{word}")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    result['found']
  end

end
