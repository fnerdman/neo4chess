class Player < Neo4j::Rails::Model
  property :name, :type => String, :index => :exact

  has_n :playedWhite
  has_n :playedBlack
end
