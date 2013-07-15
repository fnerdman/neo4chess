class Game < Neo4j::Rails::Model
  property :id, :type => String, :index => :exact
  property :name, :type => String, :index => :exact
  property :halfturns, :type => Fixnum
  property :result, :type => String
  property :date, :type => DateTime
  property :mode, :type => String
  property :site, :type => String

  has_one :startsAt
  has_n :positions

  	def whitePlayer
		self.incoming(:playedWhite).first
	end
	
	def blackPlayer
		self.incoming(:playedBlack).first
	end
	
	def event
		self.incoming(:playedGames).first
	end

	def startingPosition
		self.outgoing(:startsAt).first
	end

  	def positionLinks
		poss = self.rels(:outgoing,:positions)
		sequ = Array.new(poss.count)
		poss.each do |pos|
			sequ[pos.nHalfturns] = pos
		end
		sequ
	end

  	def self.addGame gameWrapper
		Neo4j::Transaction.run do
		
			gameInfo = gameWrapper.gameInfo

			white = Player.find_or_create_by(:name => gameInfo.white)
			black = Player.find_or_create_by(:name => gameInfo.black)
			event = Event.find(:name => gameInfo.event)
			if !event
				event = Event.create(:name => gameInfo.event)
				event.date = gameInfo.date
				event.site = gameInfo.site
			end

			game = Game.create(:result => gameInfo.result, :date => gameInfo.date, :site => gameInfo.site)
			white.playedWhite << game
			black.playedBlack << game
			event.playedGames << game
			
			
			x = game.halfturns = gameWrapper.moves.count
			x-=1
			lastPos = nil
			pos = nil
			gameWrapper.moves.reverse_each do |move|
				lastPos = pos
				pos = Position.find_or_create_by(:fen => move[0])

				Neo4j::Rails::Relationship.create(:positions, game, pos, :nHalfturns => x, :move => move[1])
				
				if lastPos
					Move.create(:moveTo, pos, lastPos, :gameId => game.id, :nHalfturns => x, :move => move[1])
				end

				x-=1
			end
		
			Move.create(:startsAt,game,pos, :gameId => game.id)
		end
	end
end
