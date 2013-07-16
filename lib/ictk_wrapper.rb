require 'java'
require 'ictk.jar'


import 'ictk.boardgame.chess.io.PGNReader'
import 'ictk.boardgame.chess.io.FEN'

class GameInfo
	def initialize gameInfo
		@gameInfo = gameInfo
	end
	
	def date
		d = @gameInfo.getDateString
		arr = [1970,1,1]
		y = 0
		d.split(/\.|\?/).each do |x|
			arr[y]=x.to_i
			y+=1
		end
		Time.local(arr[0], arr[1], arr[2]) 
	end
	
	def event
		@gameInfo.getEvent
	end
	
	def white
		@gameInfo.getPlayers[0].getName
	end
	
	def black
		@gameInfo.getPlayers[1].getName
	end
	
	def result
		@gameInfo.getResult
	end
	
	def round
		@gameInfo.getRound
	end
	
	def site
		@gameInfo.getSite
	end
end

class IctkGame

	@@fen = FEN.new

	def removeNumbers fen
		fen.split(/\s[0-9]+\s[0-9]+/).first
	end

	def initialize game
		@game = game
		@gameInfo = GameInfo.new game.getGameInfo
		@moves = []
		
		h = @game.getHistory

		fen = removeNumbers(@@fen.boardToString(h.getNext.getBoard))
		comment = (h.getNext.getAnnotation ? h.getNext.getAnnotation.getComment : "")
		while h.hasNext
			m = h.next
			@moves << [fen, m.toString, comment]
			fen = removeNumbers(@@fen.boardToString(m.getBoard))
			comment = (m.getAnnotation ? m.getAnnotation.getComment : "")
		end
		@moves << [fen, @gameInfo.result.toString, comment]
	end
	
	attr_reader :positions, :moves, :gameInfo
end

class IctkWrapper
	def self.createGamesFromPgn pgn
		game = String.new
		failed = 0
		all = 0
		moves = false
		pgn.each do |line| 
			
			if line["["]
				if moves
					moves = false
					is = java.io.ByteArrayInputStream.new game.to_java_bytes
					br = java.io.BufferedReader.new java.io.InputStreamReader.new(is)	 
					all+=1
					begin
						yield IctkGame.new(PGNReader.new(br).readGame)
					rescue => err
						puts "failed:\n#{err}"
						failed+=1
					end
					game = ""
				end
			else
				moves = true
			end
			game += line+"\n"
		end
		[all,all-failed,failed]
	end
end