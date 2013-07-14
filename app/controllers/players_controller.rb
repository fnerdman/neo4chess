class PlayersController < ApplicationController
  # GET /players
  # GET /players.json
  def index
    if params[:q]
      @players = QueryController.searchPlayer params[:q]
    else
      @players = Player.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @players }
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @player = Player.find(params[:id])
    #@games = QueryController.getPlayerGames(@player)

    #render :partial => "games/game", :object => @games
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @player }
      
    end
  end
end
