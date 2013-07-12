class Commentary < Neo4j::Rails::Model
  property :title, :type => String
  property :body, :type => String

  has_one :commentsOn
end
