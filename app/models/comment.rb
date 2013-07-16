class Comment < Neo4j::Rails::Model
  property :title, :type => String
  property :body, :type => String

  validates :title, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: false

  has_one :commentsOn
end
