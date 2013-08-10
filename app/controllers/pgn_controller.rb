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

	    avg2time = 0
	    avgTime = 0
	    check0 = Time.now
	    counter = 0

	    stats = IctkWrapper.createGamesFromPgn(games,addNewLines) do |game|
	    	innerCheck = Time.now
	        Game.addGame game
	        avg2time += Time.now-innerCheck
	        counter+=1

	        if counter == 100
	        	avgtime += avg2time
	        	puts "100 games processed, avgtime per game: #{avg2time/100}"
	        	avg2time=0
	        	counter=0
	        end
	      end

	    check1 = Time.now
	    avgtime += avg2time
	    avgTime/=stats[1]

	      flash[:notice] = "#{stats[0]} Games processed, #{stats[1]} successful, #{stats[2]} failed. Total time taken: #{check1-check0}s. Average per Game: #{avgTime}s"
	      puts "Finished uploading Games:"
	      puts flash[:notice] 
	      redirect_to :back
	end
  end
end
