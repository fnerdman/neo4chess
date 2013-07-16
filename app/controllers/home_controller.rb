class HomeController < ApplicationController
  def index
  	render layout: "root"
  end

  def traverse
    @position = SearchController.searchPosition('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -').first

    redirect_to position_path(@position.id)
  end
end
