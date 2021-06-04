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
    @p_size = 200
    @p_left = WIDTH / 2 - @p_size / 2
    @p_right = WIDTH / 2 + @p_size / 2
    @last_move = Time.now
  end

  attr_accessor :p_size, :p_left, :p_right

  def draw
    Line.new(x1: @p_left,
             y1: HEIGHT - 10,
             x2: @p_right,
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
  def initialize
    @x = WIDTH / 2
    @y = HEIGHT / 2
    @speed = 5
    @angle = rand(-5.0..5.0)
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

class Game
  def initialize
    @platform = Platform.new
    @ball = Ball.new
    @running = true
    @bricks = create_wall_of_bricks
    @last_low_brick = Time.now
    @sweet = Sweet.new
    @last_sweet = Time.now
  end

  attr_accessor :platform, :ball, :running, :bricks, :sweet

  def ball_hit_platform?
    if @ball.y > HEIGHT - 25 && (@platform.p_left..@platform.p_left + @platform.p_size / 4).to_a.include?(@ball.x.to_i)
      @ball.angle -= 2
      return true
    elsif @ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size / 4..@platform.p_left + @platform.p_size / 2).to_a.include?(@ball.x.to_i)
      @ball.angle -= 1
      return true
    elsif @ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size / 2..@platform.p_left + @platform.p_size * 3 / 4).to_a.include?(@ball.x.to_i)
      @ball.angle += 1
      return true
    elsif @ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size * 3 / 4..@platform.p_left + @platform.p_size).to_a.include?(@ball.x.to_i)
      @ball.angle += 2
      return true
    end
  end

  def ball_hit_top?
    @ball.y < 10
  end

  def ball_hit_wall?
    @ball.x < 10 || @ball.x > WIDTH - 10
  end

  def ball_hit_floor?
    @ball.y > HEIGHT - 10
  end

  def create_wall_of_bricks
    bricks = []
    x = 0
    y = 40
    b_index = 0
    4.times do
      15.times do
        bricks << Brick.new(x, y, b_index)
        x += 40
        b_index += 1
      end
      y += 22
      x = 0
    end
    bricks
  end

  def ball_hit_brick
    @bricks.each do |brick|
      if (brick.y - 10..brick.y + 30).to_a.include?(@ball.y) && (brick.x..brick.x + 40).to_a.include?(@ball.x.to_i)
        @ball.bump('verticaly')
        @bricks.delete(brick)
      elsif (brick.y..brick.y + 20).to_a.include?(@ball.y) && (brick.x - 10..brick.x + 50).to_a.include?(@ball.x.to_i)
        @ball.bump('horizontaly')
        @bricks.delete(brick)
      end
    end
  end

  def low_brick
    if Time.now - @last_low_brick > 20
      @bricks.each { |b| b.y += 10 }
      @last_low_brick = Time.now
    end
  end

  def create_sweet
    if Time.now - @last_sweet > 5
      @sweet = Sweet.new
      @last_sweet = Time.now
    end
  end
end

class Brick
  def initialize(x, y, b_index)
    @x = x
    @y = y
    @b_index = b_index
  end

  attr_accessor :b_index, :x, :y

  def draw
    Rectangle.new(x: @x,
                  y: @y,
                  width: 38,
                  height: 20,
                  color: 'green')
  end
end

class Sweet
  def initialize
    @x = rand(10..600)
    @y = 10
  end

  attr_accessor :x, :y

  def draw
    Circle.new(x: @x,
               y: @y,
               radius: 10,
               color: '#FFC0CB')
  end

  def move
    @y += 5
  end
end

game = Game.new

update do
  if game.running
    clear
    on :key_held do |event|
      game.platform.move(event.key) if (event.key == 'left' || event.key == 'right') && game.platform.can_move?
    end
    game.platform.draw
    game.ball.move
    game.ball.draw
    game.ball.bump('verticaly') if game.ball_hit_platform? || game.ball_hit_top?
    game.ball.bump('horizontaly') if game.ball_hit_wall?
    game.running = false if game.ball_hit_floor?
    game.bricks.each(&:draw)
    game.ball_hit_brick
    game.low_brick
    game.create_sweet
    if game.sweet
      game.sweet.draw
      game.sweet.move
    end
  end
end

show
