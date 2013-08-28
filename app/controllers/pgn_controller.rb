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
	    		games = File.open("/tmp/current.pgn","r")
    		rescue => err
				return
			end
	    end

	    avg2time = 0
	    avgTime = 0
	    check0 = Time.now
	    lap = 5000
	    tc=0

	    stats = IctkWrapper.createGamesFromPgn(games,addNewLines) do |game|
	    	innerCheck = Time.now
	        Game.addGame game
	        avg2time += Time.now-innerCheck
	        tc+=1
	        if tc % lap == 0
	        	avgTime += avg2time
	        	puts "#{tc} games processed, avgtime per game for last #{lap}: #{avg2time/lap}"
	        	avg2time=0
	        	benchmark = HomeController.start_benchmark
	        	doc = "#{tc} games processed, avgtime per game for last #{lap}: #{avg2time/lap}\n"
	        	doc += "benchmark completed\n"
      			doc += "nPositions: #{benchmark[:nPositions]}, nGames #{benchmark[:nGames]}, avgGetGamePos: #{benchmark[:avgGetGamePos]}, avgPositionTraversal: #{benchmark[:avgPositionTraversal]}\n"

	        	File.open("data", 'a') {|f| f.write(doc) }
	        	
	        end
	      end

	    check1 = Time.now
	    avgTime += avg2time
	    avgTime/=stats[1]

	      flash[:notice] = "#{stats[0]} Games processed, #{stats[1]} successful, #{stats[2]} failed. Total time taken: #{check1-check0}s. Average per Game: #{avgTime}s"
	      puts "Finished uploading Games:"
	      puts flash[:notice]
	      File.open("data", 'a') {|f| f.write(flash[:notice]) } 
	      redirect_to :back
	end
  end
end
