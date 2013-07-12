class PgnController < ApplicationController
  def uploadpost
 	GameInfoFactory.createGamesFromPgn(params[:pgn].read.split(/\n/)).each do |gameInfo|
  		Game.addGame gameInfo
  	end
  
  	if true
      render action: "upload", notice: 'Player was successfully created.'
    else
      render action: "upload"
    end
  end

  def upload
  end
end
