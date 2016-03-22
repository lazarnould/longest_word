require 'open-uri'
require 'json'

class PagesController < ApplicationController

  def game
   @grid = generate_grid(rand(6..9))
  end

 def score
  start_t = DateTime.parse(params[:start_time])
  end_t = Time.now
  @guess= params[:guess].to_s
  @grid = params[:grid].chars
  fucked_up(@guess, @grid)
  run_game(@guess, @grid, start_t, end_t)
end



def fucked_up(attempt, grid)
  array = attempt.upcase.chars
  array_2 = grid.dup
  keep_calm = grid.dup
  array.each do |letter|
    if i = array_2.index(letter)
      array_2.delete_at(i)
    end
  end

  if array_2.size == keep_calm.size - array.size
    return true
  else
    return false
  end
end



def run_game(attempt, grid, start_time, end_time)
  api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
  content = open(api_url).read
  word = JSON.parse(content)
  gaming_time = end_time - start_time
  score = attempt.chars.size / gaming_time
  if !fucked_up(attempt, grid)
    score = 0
    message = "not in the grid"
  end
  if attempt.chars.size > grid.size
    score = 0
    message = "Sorry your word is too long"
  end
  if !word["Error"].nil?
    score = 0
    message = "not an english word"
  else
    translation = word["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"]
  end
  if score != 0
    message = "well done"
  end
  @result = {
   time: gaming_time,
   translation: translation,
   score: score,
   message: message
 }


end

def generate_grid(grid_size)
  Array.new(grid_size) { [*"A".."Z"].sample } # TODO: generate random grid of letters
end




end
