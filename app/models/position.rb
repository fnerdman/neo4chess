class Position < Neo4j::Rails::Model
  property :fen, :type => String, :index => :exact

  has_n :moveTo

  	def simple_fen
  		match = fen.match(/(?<sfen>.*\/.*\/.*\/.*\/.*\/.*\/.*\/.*)(\sw|\sb)/)
  		match[:sfen]
  	end

  	def comments
		self.incoming(:commentsOn).to_a
	end
	
	def evaluations
		self.incoming(:evaluates).to_a
	end

	# returns the games corecponding to
	# the game models :position edge
  	def games
  		self.incoming(:positions)
	end

	def outgoingMoves
		self.rels(:outgoing, :moveTo).to_a
	end

	def incomingMoves
		self.rels(:incoming, :moveTo).to_a
	end
end
