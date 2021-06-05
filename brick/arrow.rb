class Arrow
	def initialize
		@x1 = WIDTH / 2
		@y1 = HEIGHT - 25
		@x2 = WIDTH / 2
		@y2 = HEIGHT - 100
		@last_move = Time.now
	end

	attr_accessor :x1, :y1, :x2, :y2, :last_move

	def draw
		Line.new(x1: @x1, y1: @y1, x2: @x2, y2: @y2, color: 'white')
	end

	def move(direction)
		if direction == 'left'
			@x2 -= 0.1
			@x2 < WIDTH / 2 ? @y2 += 0.05 : @y2 -= 0.05
		elsif direction == 'right'
			@x2 += 0.1
			@x2 < WIDTH / 2 ? @y2 -= 0.05 : @y2 += 0.05
		end
	end
end
