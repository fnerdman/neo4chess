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
    if params[:name]
      @games = QueryController.searchGameByName(params[:name])
    elsif params[:gid]
      @games = QueryController.searchGameById(params[:gid])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  private

    def load_position
      @position = Position.find(params[:position_id])
    end

end
