class CommentsController < ApplicationController

  before_filter :load_position

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    rel = Neo4j::Rails::Relationship.new(:commentsOn, @comment, @position)

    respond_to do |format|
      if @comment.save and rel.save
        format.html { redirect_to @position, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to @position, error: 'Failed to create comment.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @position, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def load_position
      @position = Position.find(params[:position_id])
    end

end
