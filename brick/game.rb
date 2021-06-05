require './wall.rb'

class Game
  def initialize
    @platform = Platform.new
    @balls = [Ball.new(WIDTH / 2, HEIGHT - 25)]
    @running = true
    @level = 1
    @wall = Wall.new(@level)
    @last_low_brick = Time.now
    @sweets = []
    @score = 0
    @lifes = 3
    @started = false
    @last_next_level = Time.now
    @arrow = Arrow.new
  end

  attr_accessor :platform, :balls, :running, :wall, :sweets, :score, :lifes, :started, :level, :last_next_level, :last_low_brick, :arrow

  def ball_hit_platform?
    @balls.each do |ball|
      if ball.y > HEIGHT - 25 && (@platform.p_left..@platform.p_left + @platform.p_size / 4).to_a.include?(ball.x.to_i)
        ball.angle -= 2
        ball.speed *= -1
      elsif ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size / 4..@platform.p_left + @platform.p_size / 2).to_a.include?(ball.x.to_i)
        ball.angle -= 1
        ball.speed *= -1
      elsif ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size / 2..@platform.p_left + @platform.p_size * 3 / 4).to_a.include?(ball.x.to_i)
        ball.angle += 1
        ball.speed *= -1
      elsif ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size * 3 / 4..@platform.p_left + @platform.p_size).to_a.include?(ball.x.to_i)
        ball.angle += 2
        ball.speed *= -1
      end
    end
  end

  def ball_hit_top?
    @balls.each { |ball| ball.bump('verticaly') if ball.y < 10 }
  end

  def ball_hit_wall?
    @balls.each do |ball|
      ball.bump('horizontaly') if ball.x < 10 || ball.x > WIDTH - 10
    end
  end

  def ball_hit_floor?
    if @balls.empty?
      @platform = Platform.new
      return @started = false
    end
    @balls.each { |ball| @balls.delete(ball) if ball.y > HEIGHT - 10 }
  end

  def ball_hit_brick?
    @balls.each do |ball|
      @wall.bricks.each do |brick|
        if (brick.y - 10..brick.y + 30).to_a.include?(ball.y) && (brick.x..brick.x + 40).to_a.include?(ball.x.to_i)
          ball.bump('verticaly') # here ??                                                                                    <<-----<<----<<
          brick.solidity -= 1
          @wall.bricks.delete(brick) unless brick.solidity.positive?
          @score += 10 unless brick.type == 'indestructible'
          if brick.type == 'bigger'
            @sweets << Sweet.new(brick.x + 20, brick.y + 10)
          elsif brick.type == 'double'
            @balls << Ball.new(@platform.p_right - @platform.p_size / 2, HEIGHT - 25)
          end
        elsif (brick.y..brick.y + 20).to_a.include?(ball.y) && (brick.x - 10..brick.x + 50).to_a.include?(ball.x.to_i)
          ball.bump('horizontaly')
          brick.solidity -= 1
          @wall.bricks.delete(brick) unless brick.solidity.positive?
          @score += 10 unless brick.type == 'indestructible'
          if brick.type == 'bigger'
            @sweets << Sweet.new(brick.x + 20, brick.y + 10)
          elsif brick.type == 'double'
            @balls << Ball.new(@platform.p_right - @platform.p_size / 2, HEIGHT - 25)
          end
        end
      end
    end
  end

  def low_brick
    if Time.now - @last_low_brick > 10
      @wall.bricks.each { |b| b.y += 10 }
      @last_low_brick = Time.now
    end
  end

  def ball_hit_sweet?
    @sweets.each do |sweet|
      next unless sweet.y > HEIGHT - 25 && (@platform.p_left..@platform.p_right).to_a.include?(sweet.x.to_i)

      @sweets.delete(sweet)
      @platform.p_size += 20
      @platform.p_left -= 10
      @platform.p_right += 10
    end
  end

  def fail?
    @running = false if @wall.bricks.empty?
    if @balls.empty?
      @lifes -= 1
      @balls << Ball.new(WIDTH / 2, HEIGHT - 25, 0)
      @started = false
      @platform = Platform.new
    end
  end

  def game_over?
    return if @lifes >= 0

    @running = false
  end

  def play
    Text.new("Score: #{@score}")
    Text.new("Lifes: #{@lifes}", y: 18, color: 'red')
    Text.new("LEVEL #{@level}", x: 500, color: 'orange')
    @platform.draw
    @balls.each { |ball| ball.move if @started }
    @balls.each(&:draw)
    ball_hit_platform?
    ball_hit_top?
    ball_hit_wall?
    ball_hit_floor?
    @wall.bricks.each(&:draw)
    ball_hit_brick?
    low_brick
    @sweets.each(&:draw) unless @sweets.empty?
    @sweets.each(&:move) unless @sweets.empty?
    ball_hit_sweet?
    fail? if @started
    game_over?
  end

  def next_level
    @balls = [Ball.new(WIDTH / 2, HEIGHT - 25)]
    @level += 1
    @wall = Wall.new(@level)
    @running = true
    @started = false
    @platform = Platform.new
    @last_next_level = Time.now
    @arrow = Arrow.new
  end
end
