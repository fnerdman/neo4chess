class Game < Neo4j::Rails::Model
  property :id, :type => String, :index => :exact
  property :name, :type => String, :index => :exact
  property :halfturns, :type => Fixnum
  property :result, :type => String
  property :date, :type => DateTime
  property :mode, :type => String
  property :site, :type => String

  has_one :startsAt

  	def self.addGame gameInfo
		Neo4j::Transaction.run do
		
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
			
			gameId = game.neo_id
			game.id = gameId
			
			game.halfturns = gameInfo.positions.count
			x = gameInfo.positions.count-1
			lastPos = nil
			pos = nil
			gameInfo.positions.reverse_each do |fen|
				lastPos = pos
				pos = Position.find_or_create_by(:fen => fen)
				
				if lastPos
					Move.create(:moveTo, pos, lastPos, :gameId => gameId, :nHalfturns => x, :move => gameInfo.moves[x])
				end
				
				x-=1
			end
		
			Move.create(:startsAt,game,pos, :gameId => gameId)
		end
	end
end
