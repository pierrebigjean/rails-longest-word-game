require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new  
    @letters = []
    10.times do |letter|
      @letters << ("A".."Z").to_a[rand(25)]
    end
    @start_time = Time.now
  end

  def score
    @time = Time.now - Time.parse(params[:start_time])
    @try = params[:try]
    @letters = params[:letters]

    user_input = @try.chars.sort.join.downcase
    original_array = @letters.chars.sort.join.downcase

    if wagon_dico(@try)["found"] == false
      @not_english = "Sorry but #{@try} is not an English word"
    elsif count(user_input, original_array)
      @score = "Your score is #{(user_input.length * 100 / @time).round()}"
      @win = "Congratulations! #{@try} is a valid English word"
    else
      @lose = "Sorry but #{@try} can't be built out of #{@letters}"
    end
  end

  private

  def count(input, array)
    validation = input.chars.all? do |letter|
      input.count(letter) <= array.count(letter)
    end
    return validation
  end
  
  def wagon_dico(input)
    url = "https://wagon-dictionary.herokuapp.com/#{input}"
    return JSON.parse(URI.open(url).read)
  end
end
