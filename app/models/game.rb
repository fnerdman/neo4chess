class Game < Neo4j::Rails::Model
  property :id, :type => String, :index => :exact
  property :name, :type => String, :index => :exact
  property :halfturns, :type => Fixnum
  property :result, :type => String
  property :date, :type => DateTime
  property :mode, :type => String
  property :site, :type => String

  has_one :startsAt
end
