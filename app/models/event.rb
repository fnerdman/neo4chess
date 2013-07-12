class Event < Neo4j::Rails::Model
  property :name, :type => String, :index => :exact
  property :site, :type => String
  property :date, :type => DateTime

  has_n :playedGames
end
