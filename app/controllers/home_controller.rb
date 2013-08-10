class HomeController < ApplicationController
  
  # starting page
  def index
  	render layout: "root"
  end

  # click on traveres and get redirected to starting chess position
  def traverse
    @position = SearchController.searchPosition('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -').first

    redirect_to position_path(@position.id)
  end

  def benchmark
  	if params[:start]
  		games = Game.all
  		@benchmark = {nPositions: Position.all.size, nGames: games.size}
  		
  		position = SearchController.searchPosition('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -').first

  		check0 = Time.now
  		100.times do |k|
  			game = Game.find(games[Random.rand(games.size)].id)
  			positions = game.positionsForBenchmark
  		end

  		check1 = Time.now

  		x = 0
  		100.times do |k|
  			pos = position
  			while !(outgoing = pos.outgoingMoves).empty?
  				pos=outgoing[Random.rand(outgoing.size)].end_node
  				x+=1
  			end
  		end

  		check2 = Time.now
  		@benchmark[:avgGetGamePos] = (check1-check0)/100
  		@benchmark[:avgPositionTraversal] = (check2-check1)/x

      puts "benchmark completed"
      puts "nPositions: #{@benchmark[:nPositions]}, nGames #{@benchmark[:nGames]}, avgGetGamePos: #{@benchmark[:avgGetGamePos]}, avgPositionTraversal: #{@benchmark[:avgPositionTraversal]}"
  	end
  end
end
