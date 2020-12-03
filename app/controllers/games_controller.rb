require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    @voyelles_select = []
    @voyelles = ['a','e','i','o','u']
    7.times { @letters << ('a'..'z').to_a.sample }
    3.times { @voyelles_select << @voyelles.to_a.sample }
    @voyelles_select.each do |voyelle|
      @letters << voyelle
    end
  end

  def score
    @result = ''
    @letters = params[:letters]
    if is_included?(params[:answer], @letters)
      if english_word?(params[:answer])
        @result = "Congratulation! #{params[:answer]} is a valid English word!"
      else
        @result = "Sorry, but #{params[:answer]} doeas not seem to be a valid English word..."
      end
    else
      @result = "Sorry, but #{params[:answer]} can't be built out of \'#{@letters.upcase}\'"
    end
    @result
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    select_word = open(url).read
    word = JSON.parse(select_word)
    word['found']
  end

  def is_included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end
end
