class PgnController < ApplicationController
  def upload
    if params[:pgn]
      #params[:pgn].read.split(/\n/).each {|line| puts line}
      stats = IctkWrapper.createGamesFromPgn(params[:pgn].read.split(/\n/)) do |game|
        Game.addGame game
      end

      flash[:notice] = "#{stats[0]} Games processed, #{stats[1]} successful, #{stats[2]} failed."
      redirect_to :back
    end
  end
end
