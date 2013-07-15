class SearchController < ApplicationController
  def index
  end

  	def self.searchPosition fen
		Position.all(:fen => fen)
	end
	
	def self.searchPlayer name
		Player.all(:name => name)
	end
	
	def self.searchEvent name
		Event.all(:name => name)
	end
	
	def self.searchGameByName name
		Game.all(:name => name)
	end
	
	def self.searchGameById id
		Game.all(:id => id)
	end
end
