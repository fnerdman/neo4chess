class Evaluation < Neo4j::Rails::Model
  property :engine, :type => String
  property :centipawns, :type => Fixnum
  property :ply, :type => Fixnum
  property :nNodes, :type => Fixnum
  property :bestPath, :type => String

  validates :engine, presence: true
  validates :centipawns, presence: true

  has_one :evaluates
end
