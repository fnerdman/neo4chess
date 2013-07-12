class CommentariesController < ApplicationController
  # GET /commentaries
  # GET /commentaries.json
  def index
    @commentaries = Commentary.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @commentaries }
    end
  end

  # GET /commentaries/1
  # GET /commentaries/1.json
  def show
    @commentary = Commentary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @commentary }
    end
  end

  # GET /commentaries/new
  # GET /commentaries/new.json
  def new
    @commentary = Commentary.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @commentary }
    end
  end

  # GET /commentaries/1/edit
  def edit
    @commentary = Commentary.find(params[:id])
  end

  # POST /commentaries
  # POST /commentaries.json
  def create
    @commentary = Commentary.new(params[:commentary])

    respond_to do |format|
      if @commentary.save
        format.html { redirect_to @commentary, notice: 'Commentary was successfully created.' }
        format.json { render json: @commentary, status: :created, location: @commentary }
      else
        format.html { render action: "new" }
        format.json { render json: @commentary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /commentaries/1
  # PUT /commentaries/1.json
  def update
    @commentary = Commentary.find(params[:id])

    respond_to do |format|
      if @commentary.update_attributes(params[:commentary])
        format.html { redirect_to @commentary, notice: 'Commentary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @commentary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commentaries/1
  # DELETE /commentaries/1.json
  def destroy
    @commentary = Commentary.find(params[:id])
    @commentary.destroy

    respond_to do |format|
      format.html { redirect_to commentaries_url }
      format.json { head :no_content }
    end
  end
end
