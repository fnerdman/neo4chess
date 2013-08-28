require 'java'
require 'ictk.jar'


import 'ictk.boardgame.chess.io.PGNReader'
import 'ictk.boardgame.chess.io.FEN'

# holds the data which ictk's game info holds, see ictk docs
class GameInfo

	def reset gameInfo
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

	def self.removeNumbers fen
		fen.split(/\s[0-9]+\s[0-9]+/).first
	end

	# saves necesary infos to create the game path in the
	# @moves array. which is later used to greate the game in
	# app/models/game
	def initialize
		@gameInfo = GameInfo.new 
	end

	def reset game
		@gameInfo.reset game.getGameInfo
		@moves = []
		
		h = game.getHistory

		fen = IctkGame.removeNumbers(@@fen.boardToString(h.getNext.getBoard))
		comment = (h.getNext.getAnnotation ? h.getNext.getAnnotation.getComment : "")
		while h.hasNext
			m = h.next
			@moves << [fen, m.toString, comment]
			fen = IctkGame.removeNumbers(@@fen.boardToString(m.getBoard))
			comment = (m.getAnnotation ? m.getAnnotation.getComment : "")
		end
		@moves << [fen, @gameInfo.result.toString, comment]
	end
	
	attr_reader :moves, :gameInfo
end

# processes raw pgn string data into single pgn games
# which are then passed to ictk's pgn reader
# note the rescue, since the ictk library is having issues
# with heavy annotated games and cant process all off them
class IctkWrapper

	def self.createGamesFromPgn pgn, addNewLines
		ictkGame = IctkGame.new
		game = String.new
		failed = 0
		all = 0
		moves = false
		pgn.each do |line| 
			if line["["]
				if moves
					moves = false
					all+=1
					begin
						is = java.io.ByteArrayInputStream.new game.to_java_bytes
						ir = java.io.InputStreamReader.new(is)
						br = java.io.BufferedReader.new ir
						pr = PGNReader.new(br)
						ictkGame.reset(pr.readGame) 

						yield ictkGame

						pr.close
						br.close
						ir.close
						is.close
					rescue => err
						puts "failed:\n#{err.message}"
						failed+=1
					end
					
					game = ""
				end
			else
				moves = true
			end
			game += line+(addNewLines ? "\n" : "")
		end
		[all,all-failed,failed]
	end
end