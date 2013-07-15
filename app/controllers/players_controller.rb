class PlayersController < ApplicationController
  # GET /players
  # GET /players.json
  def index
    @players = []
    if params[:q]
      @players = SearchController.searchPlayer "*#{params[:q]}*"
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @player }
      
    end
  end
end
