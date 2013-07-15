class Position < Neo4j::Rails::Model
  property :fen, :type => String, :index => :exact

  has_n :moveTo

  	def comments
		self.incoming(:commentsOn).to_a
	end
	
	def evaluations
		self.incoming(:evaluates).to_a
	end

  	def games
		games = Hash.new
		self.rels(:both, :moveTo).each do |rel|
			games[rel.gameId] = Game.find(:id => rel.gameId) unless games[rel.gameId]
		end
		games.values
	end

	def outgoingMoves
		positions = Hash.new
		self.rels(:outgoing, :moveTo).each do |rel|
			positions[rel.end_node.fen] = rel
		end
		positions.values
	end

	def incomingMoves
		positions = Hash.new
		self.rels(:incoming, :moveTo).each do |rel|
			positions[rel.start_node.fen] = rel
		end
		positions.values
	end
end
