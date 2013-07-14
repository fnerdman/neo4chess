class EvaluationsController < ApplicationController

  before_filter :load_position

  # POST /evaluations
  # POST /evaluations.json
  def create
    @evaluation = Evaluation.new(params[:evaluation])
    rel = Neo4j::Rails::Relationship.new(:evaluates, @evaluation, @position)

    respond_to do |format|
      if @evaluation.save and rel.save
        format.html { redirect_to @position, notice: 'Evaluation was successfully created.' }
        format.json { render json: @evaluation, status: :created, location: @evaluation }
      else

        format.html { redirect_to @position, error: 'Failed to create comment.' }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluations/1
  # DELETE /evaluations/1.json
  def destroy
    @evaluation = Evaluation.find(params[:id])
    @evaluation.destroy

    respond_to do |format|
      format.html { redirect_to @position, notice: 'Evaluation was successfully destroyed.'  }
      format.json { head :no_content }
    end
  end

  private

    def load_position
      @position = Position.find(params[:position_id])
    end
end
