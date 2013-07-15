class PositionsController < ApplicationController
  # GET /positions
  # GET /positions.json
  def index
    @positions = []
    if params[:q]
      @positions = SearchController.searchPosition params[:q]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
    @position = Position.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @position }
    end
  end
end
