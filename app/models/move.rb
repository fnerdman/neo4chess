class Move < Neo4j::Rails::Relationship
	property :gameId, :type => Fixnum
	property :move, :type => String	
end