class Game < Neo4j::Rails::Model
  property :id, :type => String, :index => :exact
  property :name, :type => String , :index => :exact
  property :halfturns, :type => Fixnum
  property :result, :type => String
  property :date, :type => DateTime
  property :mode, :type => String
  property :site, :type => String

  has_one :startsAt
  has_n :positions


  	# Queries section, see neo4j.rb documentation for
  	# particular meaning of the methods

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
			sequ[pos.getProperty('nHalfturns')] = pos
		end
		sequ
	end

	def positionsForBenchmark
		poss = self.rels(:outgoing,:positions)
		sequ = Array.new(poss.count)
		poss.each do |pos|
			sequ[pos.getProperty('nHalfturns')] = pos.end_node
		end
		sequ
	end

	# create section
	# rather bulky code which creates a game read from a pgn
	# file, and at the same time checks for data integrity
	# => no two players with the same name etc.
	# and after that creates the game path through the positions

  	def self.addGame ictkGame
		Neo4j::Transaction.run do
		
			gameInfo = ictkGame.gameInfo

			gamename = "#{gameInfo.white} vs #{gameInfo.black} (#{gameInfo.result}), #{gameInfo.date.strftime("%d.%m.%Y")}"
			gamename += ", #{gameInfo.event}" unless !gameInfo.event or !gameInfo.event.match(/[a-z0-9]/) 
			gamename += ", #{gameInfo.site}" unless !gameInfo.site or !gameInfo.site.match(/[a-z0-9]/)
			gamename += ", #{gameInfo.round}" unless !gameInfo.round or !gameInfo.round.match(/[a-z0-9]/)
			
			check0 = Time.now
			game = Game.find(:name => gamename)
			if !game

				white = Player.find_or_create_by(:name => gameInfo.white)
				black = Player.find_or_create_by(:name => gameInfo.black)
				event = Event.find(:name => gameInfo.event)
				if !event
					event = Event.create(:name => gameInfo.event, :date => gameInfo.date, :site => gameInfo.site)
				end
				x = ictkGame.moves.count
				game = Game.create(:name => gamename, :result => gameInfo.result, :date => gameInfo.date, :site => gameInfo.site, :halfturns => x)

				Neo4j::Relationship.new(:playedWhite,white,game)
				Neo4j::Relationship.new(:playedBlack,black,game)
				Neo4j::Relationship.new(:playedGames,event,game)
				
				x-=1
				lastPos = nil
				pos = nil
				ictkGame.moves.reverse_each do |move|
					lastPos = pos
					pos = Position.find_or_create_by(:fen => move[0])
					
					if move[2] and move[2].match(/[a-z0-9]/) 
						comment = Comment.create(:title => game.name, :body => move[2])
						Neo4j::Relationship.new(:commentsOn, comment, pos)
					end

					Neo4j::Relationship.new(:positions, game, pos, :nHalfturns => x, :move => move[1])
					if lastPos
						Neo4j::Relationship.new(:moveTo, pos, lastPos, :gameId => game.id, :move => move[1])
					end

					x-=1
				end

				Neo4j::Relationship.new(:startsAt,game,pos, :gameId => game.id)
			end
		end
	end
end
