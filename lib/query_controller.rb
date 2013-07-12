class QueryController

	def self.searchPosition fen
		Position.find(:fen => fen)
	end
	
	def self.searchPlayer name
		Player.find(:name => name)
	end
	
	def self.searchEvent name
		Event.find(:name => name)
	end
	
	def self.searchGameByName name
		Game.find(:name => name)
	end
	
	def self.searchGameById id
		Game.find(:id => id)
	end
	
	def self.getWhitePlayer(game)
		game.incoming(:playedWhite).first
	end
	
	def self.getBlackPlayer game
		game.incoming(:playedBlack).first
	end
	
	def self.getEvent game
		game.incoming(:playedGames).first
	end
	
	def self.getCommentaries position
		if position 
			return position.incoming(:commentsOn).to_a
		end
	end
	
	def self.getEvaluations position
		if position 
			return position.incoming(:evaluates).to_a
		end
	end
	
	def self.getPlayerGames player
		if player
			return player.outgoing(:playedWhite).to_a + player.outgoing(:playedBlack).to_a
		end
	end
	
	def self.getEventGames event
		if event
			return event.outgoing(:playedGames).to_a
		end
	end

	def self.getGames position
		games = Hash.new
		if position and rels = position.rels(:both, :moveTo)
			rels.each do |rel|
				game = Game.find(:id => rel.gameId)
				games[game.id] = game
			end
		end
		games.values
	end
	
	def self.getOutgoingPositions position
		positions = Hash.new
		if position and rels = position.rels(:outgoing, :moveTo)
			rels.each do |rel|
				positions[rel.end_node.fen] = rel.end_node
			end
		end
		positions.values
	end
	
	def self.getIncomingPositions position
		positions = Hash.new
		if position and rels = position.rels(:incoming, :moveTo)
			rels.each do |rel|
				positions[rel.start_node.fen] = rel.start_node
			end
		end
		positions.values
	end
	
	def self.getGameSequence gameId
		moves = Move.find(:all, :gameId => gameId)
		sequ = Array.new(moves.count-1)
		moves.each do |move|
			if move.rel_type == :moveTo
				sequ[move.nHalfturns] = move.start_node
			end
		end
		sequ
	end
	
	def self.getGameSequenceNotWorking gameId
		sequence = []
		game = Game.find(:id => gameId).first
		x=0
		
		if game and pos = game.rels(:outgoing, :startsAt).first.end_node
			
			while true
				puts pos.fen
				sequence << pos
				pos.rels(:outgoing, :moveTo).each {|rel| puts rel.gameId}
				poss = pos.rels(:outgoing, :moveTo).find(:gameId => gameId)
				if poss.count > 1
					found = false
					poss.each do |rel|
						if rel.nHalfturns == x
							found = true
							pos = rel.end_node
							break
						end
					end
					raise StandardError, "could not find position with exact halfturn: pos=#{pos.fen},game=#{gameId},halfTurn=#{x}" unless found
				elsif poss.count == 1
					pos = poss.first.end_node
				else
					break
				end
				x+=1
			end
		end
		sequence
	end
end

def test6
end

def test1
	pos = Position.find(:fen => "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR").first

	puts "start"
	posa = true
	while posa
		posa = false
		puts pos.fen
		puts pos.neo_id
		puts pos.rels(:outgoing).inspect
		pos.rels(:outgoing).find(:gameId => 1).each do |rel|
				puts rel.inspect
				puts rel.gameId
				puts rel.end_node.neo_id
				puts rel.end_node.fen
				if rel.end_node.fen != pos.fen
					posa = true
					pos = rel.end_node
				end
		end
	end
	puts "end"
	Move.find(:gameId => 1).first.end_node.rels(:outgoing,:moveTo).each do |pos|
		puts pos.gameId
	
	end

	game.rels(:both).each do |rel|
		puts rel.rel_type
	end
end

def test2
	pos = Position.find(:fen => "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR").first
	
	puts "start outgoing\n\n\n"
	pos.rels(:outgoing).each do |game|
		puts game.inspect
		puts game.end_node.inspect
	end
	puts "start incoming \n\n\n"
	pos.rels(:incoming).each do |game|
		puts game.inspect
		puts game.nHalfturns
		puts game.gameId
		puts game.rel_type
		puts game.start_node.inspect
	end
end

def test3
	game = Game.find(:id => 4).first
	game.rels(:both).each do |rel|
		puts rel.inspect
		puts rel.rel_type
		puts rel.end_node.inspect
	end
end

def testx
	sequ = Querycontroller.getGameSequence 4
	
	sequ.each {|pos| puts pos.fen}
end


def test4
	pos = Position.find(:fen => "rnbqkbnr/ppp1pppp/8/3p4/8/8/PPPPPPPP/RNBQKBNR").first
	puts Querycontroller.getIncomingPositions(pos).count
	Querycontroller.getIncomingPositions(pos).each do |pos|
		puts pos.fen
	end
end

def test5
	pos = Position.find(:fen => "rnbqkbnr/ppp1pppp/8/3p4/8/8/PPPPPPPP/RNBQKBNR").first
	Querycontroller.getGames(pos).each do |pos|
		puts pos.id
	end
end
