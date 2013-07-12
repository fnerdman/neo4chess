class Position < Neo4j::Rails::Model
  property :fen, :type => String, :index => :exact

  has_n :moveTo
end
