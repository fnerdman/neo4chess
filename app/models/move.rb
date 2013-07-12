class Move < Neo4j::Rails::Relationship
	property :gameId, :type => Fixnum, :index => :exact
	property :nHalfturns, :type => Fixnum
end