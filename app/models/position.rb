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

  	def games
  		self.incoming(:positions)
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
