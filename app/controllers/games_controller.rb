require 'json'
require 'open-uri'
ActionDispatch::Session::CookieStore

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @score_count = 0
    if included?(@word, @letters)
      if valid_word?(@word)
        @score_count += @word.length
      @result = "Congratulations! #{@word.capitalize} is a valid English word. Your score is now #{@score_count}"
      else
      @result = "Sorry but #{@word.capitalize} is not a valid English word"
      end
    else
      @result = "Sorry but #{@word.capitalize} cannot be built out of @letters"
    end
    @total_score = @score_count
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result = open(url).read
    json = JSON.parse(result)
    true if json['found'] == true
  end
end



# The word can't be built out of the original grid
# The word is valid according to the grid, but is not a valid English word
# The word is valid according to the grid and is an English word (use API)
