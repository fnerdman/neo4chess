# ideen und code zum teil von
# https://github.com/xunker/uci/blob/master/lib/uci.rb

class GameInfo

	def initialize(positions, result, white=nil, black=nil, date=nil, event=nil, site=nil, round=nil)
		@positions = positions
		@white = white
		@black = black
		@event = event
		@site = site
		arr = [1970,1,1]
		y = 0
		if date
			date.split(/\.|\?/).each do |x|
				arr[y]=x.to_i
				y+=1
			end
		end
		@date = Time.local(arr[0], arr[1], arr[2]) 
		@round = round
		@result = result
	end
	attr_reader :positions, :result, :white, :black, :date, :event, :site, :round
end

class GameInfoFactory

	RANKS = {
    	'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3,
    	'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7
	}
	PIECES = {
		'p' => :pawn,
		'r' => :rook,
		'n' => :night,
		'b' => :bishop,
		'k' => :king,
		'q' => :queen
	}

	def initialize
		reset
	end
	
	def reset
		@tags = Hash.new
		@black = false
		@enPass = nil
		@positions = Array.new
		resetBoard!
		@positions << toFEN
	end
	
	def resetBoard!
		@board = []
		8.times do |x|
		  @board[x] ||= []
		  8.times do |y|
		    @board[x] << nil
		  end
		end
		
		%w[a b c d e f g h].each do |f|
			placePiece(:white, :pawn, "#{f}2")
			placePiece(:black, :pawn, "#{f}7")
		end

		placePiece(:white, :rook, "a1")
		placePiece(:white, :rook, "h1")
		placePiece(:white, :night, "b1")
		placePiece(:white, :night, "g1")
		placePiece(:white, :bishop, "c1")
		placePiece(:white, :bishop, "f1")
		placePiece(:white, :king, "e1")
		placePiece(:white, :queen, "d1")

		placePiece(:black, :rook, "a8")
		placePiece(:black, :rook, "h8")
		placePiece(:black, :night, "b8")
		placePiece(:black, :night, "g8")
		placePiece(:black, :bishop, "c8")
		placePiece(:black, :bishop, "f8")
		placePiece(:black, :king, "e8")
		placePiece(:black, :queen, "d8")
	end
	  
	# place a piece on the board, regardless of occupied state
	#
	# ==== Attributes
	# * player - symbol: :black or :white
	# * piece - symbol: :pawn, :rook, etc
	# * position - a2, etc
	def placePiece(player, piece, position)
		rank = RANKS[position.downcase.split('').first]
		file = position.split('').last.to_i-1
		icon = piece.to_s.split('').first
		(player == :black ? icon.downcase! : icon.upcase!)
		@board[rank][file] = icon
	end

	def addTag name,value
		@tags[name] = value
	end
	
	def addRawMoves moves
		moves.each do |move|
			movePiece move
		end
	end
	
	def createGameInfo
		white = @tags["White"]
		black = @tags["Black"]
		event = @tags["Event"]
		site = @tags["Site"]
		date = @tags["Date"]
		round = @tags["Round"].to_i
		result = @tags["Result"]
		
		GameInfo.new(@positions, result, white, black, date, event, site, round)
	end
	
	def movePiece moveString
		s = /((?<fig>K|Q|R|B|N)?(?<from>[a-h]|[1-8])?(?<x>x)?(?<dest>[a-h][1-8]))|(?<roch>O\-O(\-O)?)|(?<scor>0\-1|1\-0|1\/2\-1\/2|\*)/.match(moveString)
		#puts moveString
		if @newRound then @enPass = nil end
		@newRound = true
		@wand = nil
		if s[:roch]
			f = @black ? 7 : 0
			k = @board[4][f]
			if /O\-O\-O/.match(moveString)	
				r = @board[0][f]
				@board[4][f] = @board[0][f] = nil
				@board[2][f] = k
				@board[3][f] = r
			else
				r = @board[7][f]
				@board[4][f] = @board[7][f] = nil
				@board[6][f] = k
				@board[5][f] = r
			end
			
		elsif s[:dest]
			dest = s[:dest]
			fig = s[:fig] ? s[:fig]:"P"
			from = s[:from]
			
			# search for possible Positions
			rank = RANKS[dest.downcase.split('').first]
			file = dest.split('').last.to_i-1
			posPos = Array.new
			if fig == "P"
				if t = /=(?<wand>K|Q|R|B|N)/.match(moveString)
					@wand = t[:wand]
				end
				posPos+=checkPawn(rank,file)
			elsif fig == "K"
				posPos+=checkRook(fig,rank,file,true);
				posPos+=checkBishop(fig,rank,file,true);
			elsif fig == "Q"
				posPos+=checkRook(fig,rank,file);
				posPos+=checkBishop(fig,rank,file);
			elsif fig == "R"
				posPos+=checkRook(fig,rank,file);
			elsif fig == "B"
				posPos+=checkBishop(fig,rank,file);
			elsif fig == "N"
				posPos+=checkKnight(rank,file);
			end
			
			# sort out duplicates
			if from
				if /[1-8]/.match(from)
					rk = from.split('').first.to_i-1
					tmpPos = Array.new
					posPos.each do |x|
						if x[1]==rk
							tmpPos << x
						end
					end
					posPos=tmpPos
				else
					
					rk = RANKS[from.downcase.split('').first]
					tmpPos = Array.new
					posPos.each do |x|
						if x[0]==rk
							tmpPos << x
						end
					end
					posPos=tmpPos
				end
			end
			
			if posPos.length > 1
				tmpPos = Array.new
				posPos.each do |x|
					if !checkPin(fig,x[0],x[1])
						tmpPos << x
					end
				end
				posPos = tmpPos
			end
			
			if posPos.length == 1
				makeMove(posPos[0],[rank,file],s[:x] ? s[:x] : false)
			else
				raise StandardError, "no distinct origin for move found, posPos:"+posPos.to_s+", fig=#{fig}, Movetext: #{moveString}"
			end
		elsif s[:scor]
		else
			raise StandardError, "unmatched entry in pgn-Movetext: #{moveString}\n"
		end
		@black = @black ? false : true
		#puts board
		@positions << toFEN
		#puts @black ? "black" : "white"
	end
	
	def makeMove orig, dest, capt=false
		fig = @board[orig[0]][orig[1]]
		if fig !=nil and !(capt and @board[dest[0]][dest[1]]==nil)
			if fig=='P' or fig=='p' and (orig[1]-dest[1]).abs==2
				@enPass = [orig[0],orig[1]+(@black ? -1 : 1)]
				@newRound = false
			end
			@board[orig[0]][orig[1]] = nil
			@board[dest[0]][dest[1]] = @wand ? @wand : fig
		elsif @enPass and @enPass==dest
			@board[orig[0]][orig[1]] = nil
			@board[dest[0]][dest[1]] = fig
			@board[dest[0]][dest[1]+(@black ? 1 : -1)] = nil
		else
			raise StandardError, "cant solve capture"
		end
	end
	
	def checkPin fig,rank,file
		figu = fig
		arr = Array.new(4,String.new)

		
		8.times do |x|
			if @board[rank][x]
				arr[0]+=@board[rank][x]
			end
			if @board[x][file]
				arr[2]+=@board[x][file]
			end
		end
		
		k=[rank,file].min
		r=rank-k
		f=file-k
		while r < 8 and f < 8
			if @board[r][f]
				arr[1]+=@board[r][f].to_s
			end
			r+=1
			f+=1
		end
		
		k = [rank,7-file].min
		r=rank-k
		f=file+k
		while r < 8 and f >= 0
			if @board[r][f]
				arr[3]+=@board[r][f]
			end
			r+=1
			f-=1
		end
		
		k = 'K'
		q = 'q'
		r = 'r'
		b = 'b'
		
		
		if @black
			figu.downcase!
			k.downcase!
			q.upcase!
			r.upcase!
			b.upcase!
		end
		
		pinned = false
		[0,2].each do |x|
			if /((#{q}|#{r})#{figu}#{k})|(#{k}#{figu}(#{q}|#{r}))/.match(arr[x]) or
			/(#{q}|#{b})#{figu}#{k}|(#{k}#{figu}(#{q}|#{b}))/.match(arr[x+1])
				pinned = true
			end
		end
		pinned
	end
	
	def checkPawn rank,file
		posPos = Array.new
		isAttack = !(@board[rank][file].nil?)
		fig = @black ? 'p' : 'P'
		fil = file +(@black? +1: -1)
		if @board[rank][file].nil?

			if @board[rank][fil]==fig
				posPos << [rank,fil]
			end
			
			if @black and file == 4 and @board[rank][fil].nil? and @board[rank][fil+1]==fig
				posPos << [rank,fil+1]
			elsif !@black and file == 3 and @board[rank][fil].nil? and @board[rank][fil-1]==fig
				posPos << [rank,fil-1]
			end 
			
			if @enPass and @enPass[0]==rank and @enPass[1]==file
				if @board[rank-1] and @board[rank-1][fil]==fig
					posPos << [rank-1,fil]
				end
				if @board[rank+1] and @board[rank+1][fil]==fig
					posPos << [rank+1,fil]
				end
			end
		else
			if @board[rank-1] and @board[rank-1][fil]==fig
				posPos << [rank-1,fil]
			end
			if @board[rank+1] and @board[rank+1][fil]==fig
				posPos << [rank+1,fil]
			end
		end
		
		posPos
	end
	
	def checkRook fig,rank,file,king=false
		figu = fig
		if @black then figu.downcase! end
		posPos = Array.new
		[1,-1].each do |y|
			2.times do |z|
				(king ? 1 : 7).times do |x|
					r=rank+(1+x)*y*((0+z)%2)
					f=file+(1+x)*y*((1+z)%2)
					if r>=0 and r<8 and f>=0 and f<8
						if @board[r][f]
							if @board[r][f]==figu
								posPos << [r,f]
							end
							break
						end
					else
						break
					end
				end
			end
		end
		posPos
	end
	
	def checkBishop fig,rank,file,king=false
		figu = fig
		if @black then figu.downcase! end
		posPos = Array.new
		[1,-1].each do |y|
			[1,-1].each do |z|
				(king ? 1 : 7).times do |x|
					r=rank+(1+x)*y
					f=file+(1+x)*z
					if r>=0 and r<8 and f>=0 and f<8
						if @board[r][f]
							if @board[r][f]==figu
								posPos << [r,f]
							end
							break
						end
					else
						break
					end
				end
			end
		end
		posPos
	end
	
	def checkKnight rank,file
		posPos = Array.new
		fig = @black ? 'n' : 'N'
		arr = [1,2]
		2.times do |x|
			[1,-1].each do |y|
				[1,-1].each do |z|
					r=rank+arr[(0+x)%2]*y
					f=file+arr[(1+x)%2]*z
					if r>=0 and r<8 and f>=0 and f<8 and @board[r] and @board[r][f]==fig
						posPos << [r,f]
					end
					
				end
			end
		end
		posPos
	end
	
	def toFEN
		fen = String.new
		8.times do |x|
		rank_str = ""
			empties = 0
			8.times do |y|
				r = @board[y][x]
				if r.nil?
					empties += 1
				else
					if empties > 0
						rank_str << empties.to_s
						empties = 0
					end
					rank_str << r
				end
			end
			rank_str << empties.to_s if empties > 0
			rank_str << "/" if x < 7
			fen << rank_str
		end
		fen.swapcase!
	end
	
	def self.createGamesFromPgn pgn
		games = Array.new
		rawMoves = String.new
		game = GameInfoFactory.new
		pgn.each do |line| 
			
			if line["["]
				name = /\[\s*([a-zA-Z]*)\s*\"/.match(line)
				value = /\"(.*)\"/.match(line)
				game.addTag name[1],value[1]
			else
				rawMoves += line
				if line["*"] or line["0-1"] or line["1-0"] or line["1/2-1/2"]
					moves = Array.new
					rawMoves.split(/\s*\d+\.\s*/).each do |fullMove|
						moves += fullMove.split(/\s+/)
					end
					game.addRawMoves moves
					games << game.createGameInfo
					game.reset
					rawMoves = ""
				end
			end
		end
		games
	end
end
