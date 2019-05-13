require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alpha = ('a'..'z').to_a
    @letters = []
    10.times { @letters << alpha.sample }
  end

  def score
    @user_word = params['word']
    @letters = params['letters']

    # Check if work is valid

    if can_word_be_built?(@user_word, @letters) != true
      @message = "Sorry but #{@user_word.upcase} can't be built from #{@letters.upcase}"
    elsif can_word_be_built?(@user_word, @letters) && word_exsist?(@user_word) == false
      @message = "#{@user_word.upcase} can be built, but it's not a valid word"
    elsif word_exsist?(@user_word) && can_word_be_built?(@user_word, @letters)
      @message = "Congratz! #{@user_word.upcase} is a word."
      @score = "You got #{@user_word.length} points this round"

    end
  end

  private

  def word_exsist?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    string = open(url).read # String
    api_result = JSON.parse(string) # Hash
    api_result['found']
  end

  def can_word_be_built?(word, letters)
    letters = letters.upcase.split(" ")
    word_split = word.upcase.split("")
    letters_arr = (letters & word_split).flat_map { |n| [n] * [letters.count(n), word_split.count(n)].min }
    word_split.sort == letters_arr.sort
  end
end
