class Evaluation < Neo4j::Rails::Model
  property :engine, :type => String
  property :centipawns, :type => Fixnum
  property :ply, :type => Fixnum
  property :nNodes, :type => Fixnum
  property :bestPath, :type => String

  has_one :evaluates
end
