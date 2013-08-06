require 'lib/ictk_wrapper'

class PgnController < ApplicationController
  def upload
  	if params[:none]
  		addNewLines = false
	    if params[:pgn]
	    	addNewLines = true
	    	games = params[:pgn].read.split(/\n/)
	    else
	    	begin
	    		games = File.open("/tmp/current.pgn","r").to_a
    		rescue => err
				return
			end
	    end

	    avgTime = 0
	    check0 = Time.now

	    stats = IctkWrapper.createGamesFromPgn(games,addNewLines) do |game|
	    	innerCheck = Time.now
	        Game.addGame game
	        avgTime += Time.now-innerCheck
	      end

	    check1 = Time.now
	    avgTime/=stats[0]

	      flash[:notice] = "#{stats[0]} Games processed, #{stats[1]} successful, #{stats[2]} failed. Total time taken: #{check1-check0}s. Average per Game: #{avgTime}s"
	      redirect_to :back
	end
  end
end
