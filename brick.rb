require 'ruby2d'
require 'time'

set background: 'blue'
set fps_cap: 100
set width: 600
set height: 600
WIDTH = get :width
HEIGHT = get :height

class Platform
  def initialize
    @p_size = 80
    @p_left = WIDTH / 2 - @p_size / 2
    @p_right = WIDTH / 2 + @p_size / 2
    @last_move = Time.now
    @grow = 0
  end

  attr_accessor :p_size, :p_left, :p_right, :grow

  def draw
    Line.new(x1: @p_left - @grow / 2,
             y1: HEIGHT - 10,
             x2: @p_right + @grow / 2,
             y2: HEIGHT - 10,
             width: 10)
  end

  def move(direction)
    if direction == 'left'
      if @p_left.positive?
        @p_left -= 10
        @p_right -= 10
      end
    end
    if direction == 'right'
      if @p_right < WIDTH
        @p_left += 10
        @p_right += 10
      end
    end
    @last_move = Time.now
  end

  def can_move?
    Time.now - @last_move > 0.01
  end
end

class Ball
  def initialize(x, y)
    @x = x
    @y = y
    @angle = rand(-5.0..5.0)
    @speed = -5
  end

  attr_accessor :x, :y, :angle, :speed

  def draw
    Circle.new(x: @x,
               y: @y,
               radius: 10,
               color: 'red')
  end

  def move
    @y += @speed
    @x += @angle
  end

  def bump(direction)
    @speed = -@speed if direction == 'verticaly'
    @angle = -@angle if direction == 'horizontaly'
  end
end

class Brick
  def initialize(x, y, type)
    @x = x
    @y = y
    @type = type
  end

  attr_accessor :type, :x, :y

  def draw
    if @type == 'regular'
      Rectangle.new(x: @x,
                    y: @y,
                    width: 38,
                    height: 20,
                    color: 'green')
    elsif @type == 'bigger'
      Rectangle.new(x: @x,
                    y: @y,
                    width: 38,
                    height: 20,
                    color: 'red')
      Circle.new(x: @x + 19,
                 y: @y + 10,
                 radius: 9,
                 color: '#FFC0CB')
    elsif @type == 'double'
      Rectangle.new(x: @x,
                    y: @y,
                    width: 38,
                    height: 20,
                    color: 'white')
      Circle.new(x: @x + 19,
                 y: @y + 10,
                 radius: 9,
                 color: 'red')
    end
  end
end

class Sweet
  def initialize(x, y)
    @x = x
    @y = y
  end

  attr_accessor :x, :y

  def draw
    Circle.new(x: @x,
               y: @y,
               radius: 10,
               color: '#FFC0CB')
  end

  def move
    @y += 2
  end
end

class Game
  def initialize
    @platform = Platform.new
    @balls = [Ball.new(WIDTH / 2, HEIGHT - 25)]
    @running = true
    @level = 1
    @bricks = create_wall_of_bricks(@level)
    @last_low_brick = Time.now
    @sweets = []
    @score = 0
    @lifes = 3
    @started = false
  end

  attr_accessor :platform, :balls, :running, :bricks, :sweets, :score, :lifes, :started

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

  def create_wall_of_bricks(level)
    bricks = []
    if level == 1
      x = 40
      y = 40
      2.times do
        bricks << Brick.new(x, y, 'bigger')
        x += 40
        11.times do
          bricks << Brick.new(x, y, 'regular')
          x += 40
        end
        bricks << Brick.new(x, y, 'bigger')
        y += 66
        x = 40
      end
      x = 40
      y = 62
      2.times do
        4.times do
          bricks << Brick.new(x, y, 'regular')
          x += 40
        end
        bricks << Brick.new(x, y, 'double')
        x += 40
        3.times do
          bricks << Brick.new(x, y, 'regular')
          x += 40
        end
        bricks << Brick.new(x, y, 'double')
        x += 40
        4.times do
          bricks << Brick.new(x, y, 'regular')
          x += 40
        end
        y += 22
        x = 40
      end
    elsif level == 1
      x = 40
      y = 40
      4.times do
        13.times do
          bricks << Brick.new(x, y, 'regular')
          x += 40
        end
        y += 22
        x = 40
      end
    end
    # 5.times { bricks.sample.type = 'bigger' }
    # 100.times { bricks.sample.type = 'double' }
    bricks
  end

  def ball_hit_brick?
    @balls.each do |ball|
      @bricks.each do |brick|
        if (brick.y - 10..brick.y + 30).to_a.include?(ball.y) && (brick.x..brick.x + 40).to_a.include?(ball.x.to_i)
          ball.bump('verticaly') # here ??                                                                                    <<-----<<----<<
          @bricks.delete(brick)
          @score += 10
          if brick.type == 'bigger'
            @sweets << Sweet.new(brick.x + 20, brick.y + 10)
          elsif brick.type == 'double'
            @balls << Ball.new(@platform.p_right - @platform.p_size / 2, HEIGHT - 25)
          end
        elsif (brick.y..brick.y + 20).to_a.include?(ball.y) && (brick.x - 10..brick.x + 50).to_a.include?(ball.x.to_i)
          ball.bump('horizontaly')
          @bricks.delete(brick)
          @score += 10
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
      @bricks.each { |b| b.y += 10 }
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
    @running = false if @bricks.empty?
    if @balls.empty?
      @lifes -= 1
      @balls << Ball.new(WIDTH / 2, HEIGHT - 25)
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
    @platform.draw
    @balls.each { |ball| ball.move if @started }
    @balls.each(&:draw)
    ball_hit_platform?
    ball_hit_top?
    ball_hit_wall?
    ball_hit_floor?
    @bricks.each(&:draw)
    ball_hit_brick?
    low_brick
    @sweets.each(&:draw) unless @sweets.empty?
    @sweets.each(&:move) unless @sweets.empty?
    ball_hit_sweet?
    fail? if @started
    game_over?
  end
end

game = Game.new

update do
  if game.running
    clear
    game.play
    on :key_held do |event|
      if (event.key == 'left' || event.key == 'right') && game.platform.can_move?
        game.platform.move(event.key)
        game.started = true
      end
    end
  elsif game.lifes >= 0
    Text.new('Good Job',
             x: 60,
             y: 200,
             size: 100)
    Text.new("press 'n' for next stage",
             x: 100,
             y: 300,
             size: 30)
    on :key_held do |event|
      if event.key == 'n'
        game.balls = [Ball.new(WIDTH / 2, HEIGHT - 25)]
        game.level += 1
        game.bricks = game.create_wall_of_bricks(game.level)
        game.running = true
        game.started = false
        game.platform = Platform.new
      end
    end
  else
    Text.new('Game Over',
             x: 60,
             y: 200,
             size: 100)
    Text.new("press 'r' to retry",
             x: 100,
             y: 300,
             size: 50)
    on :key_down do |event|
      game = Game.new if event.key == 'r'
    end
  end
end

show
