class GamesController < ApplicationController
  before_filter :load_position

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @position }
    end
  end

  def index
    @games = []
    if params[:pid]
      @position = Position.find(params[:pid])
      @games = @position.games

      respond_to do |format|
        format.html {redirect_to @position}
        format.js {}
        format.json { render json: @position }
      end
    else
      if params[:name]
        @games = SearchController.searchGameByName("*#{params[:name]}*")
      elsif params[:gid]
        game = SearchController.searchGameById(params[:gid])
        @games = [game] unless !game
      end

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @games }
      end
    end
  end

  private

    def load_position
      @position = Position.find(params[:position_id])
    end

end
