class HomeController < ApplicationController
  
  # starting page
  def index
  	render layout: "root"
  end

  # click on traveres and get redirected to starting chess position
  def traverse
    @position = SearchController.searchPosition('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -').first

    redirect_to position_path(@position.id)
  end
end
