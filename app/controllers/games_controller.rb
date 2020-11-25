require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alpha = ('A'..'Z').to_a
    betha = %w[A E I O U]
    @table = alpha.sample(8) + betha.sample(2)

  end

  def score
    @word = params[:word]
    @table = params[:table]
    if included?(@word.upcase, @table)
      if english_word?(@word)
        @text = "Congratulations! #{@word.upcase} is a valid English word!"
      else
        @text = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @text = "Sorry but #{@word} can't be build out of #{@table}"
    end
    @text
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
