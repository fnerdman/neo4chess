class Player < Neo4j::Rails::Model
  property :name, :type => String, :index => :exact

  has_n :playedWhite
  has_n :playedBlack

  	def games 
		self.outgoing(:playedWhite).to_a + self.outgoing(:playedBlack).to_a
	end

	def stats
		all = 0
		won = 0
		drawn = 0
		lost = 0

		self.outgoing(:playedWhite).to_a.each do |game|
			case game.result
			when /1\-0/
				won+=1
			when /0\-1/
				lost+=1
			when /1\/2\-1\/2/
				drawn+=1
			end
			all+=1
		end

		self.outgoing(:playedBlack).to_a.each do |game|
			case game.result
			when /1\-0/
				lost+=1
			when /0\-1/
				won+=1
			when /1\/2\-1\/2/
				drawn+=1
			end
			all+=1
		end

		{:all => all,:won => won,:drawn => drawn,:lost => lost}
	end
end
