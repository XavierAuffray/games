require 'ruby2d'
require 'time'

set background: 'blue'
set fps_cap: 100
set width: 600
set height: 400
WIDTH = get :width
HEIGHT = get :height
WIDTH_VALUE = 30
HEIGHT_VALUE = 20
GRID_WIDTH = WIDTH / WIDTH_VALUE
GRID_HEIGTH = HEIGHT / HEIGHT_VALUE

class Obstacle
  def initialize
    @x = 600
    @top_height = rand(10..300)
    @bottom_height = set_bottom_height
  end

  attr_accessor :x, :top_height, :bottom_height

  def set_bottom_height
    HEIGHT - @top_height - 80
  end

  def draw
    Rectangle.new(x: @x,
                  y: 0,
                  height: @top_height,
                  width: 50,
                  color: 'green')
    Rectangle.new(x: @x,
                  y: HEIGHT - @bottom_height,
                  height: @bottom_height,
                  width: 50,
                  color: 'green')
  end

  def move
    @x -= 2
  end
end

class Bird
  def initialize
    @x = 5
    @y = 0
    @last_jump = Time.now
    @last_obstacle = Time.now
    @fall_value = 0.1
    @running = true
  end

  attr_accessor :last_jump, :last_obstacle, :fall_value, :running, :x, :y

  def draw
    Circle.new(x: @x * WIDTH_VALUE,
               y: @y * HEIGHT_VALUE,
               radius: 10,
               color: 'red')
  end

  def fall
    return unless can_jump?

    @y += @fall_value
    @fall_value *= 1.02
  end

  def jump
    return unless @running

    @last_jump = Time.now
    @y -= 2
    @fall_value = 0.1
  end

  def can_jump?
    Time.now - @last_jump > 0.1
  end

  def time_to_new_obstacle
    Time.now - @last_obstacle > 1.3
  end
end

class Game
  def initialize
    @obstacles = [Obstacle.new]
    @bird = Bird.new
    @score = 0
  end

  attr_accessor :obstacles, :bird, :score

  def hit_obstacle?
    @obstacles.each do |obstacle|
      one = (@bird.x * 30 - 50..@bird.x * 30).to_a.include?(obstacle.x)
      two = @bird.y * 20 < obstacle.top_height || @bird.y * 20 > HEIGHT - obstacle.bottom_height
      return true if one && two
    end
    false
  end

  def hit_border
    @bird.y.negative? || @bird.y > 20
  end
end

game = Game.new
best_score = 0

update do
  on :key_down do |event|
    game.bird.jump if event.key == 'space' && game.bird.can_jump?
  end

  clear
  if game.bird.running
    game.bird.draw
    game.bird.fall
    game.obstacles.each do |obstacle|
      obstacle.draw
      obstacle.move
      if game.bird.time_to_new_obstacle
        game.obstacles << Obstacle.new
        game.bird.last_obstacle = Time.now
        game.obstacles.shift if game.obstacles.size > 5
        game.score += 1 if game.obstacles.size > 3
      end
    end
    if game.hit_obstacle? || game.hit_border
      game.bird.running = false
      best_score = game.score if game.score > best_score
    end
  end
  if game.bird.running
    Text.new("Score: #{game.score}")
    Text.new("Best Score: #{best_score}", y: 20)
  else
    game.obstacles.each(&:draw)
    game.bird.draw
    Text.new("Final Score: #{game.score}", x: 150, y: 150, size: 50)
    Text.new("Best Score: #{best_score}", x: 150, y: 200, size: 30)
    Text.new("press 'r' to restart", x: 150, y: 250, size: 20)
    on :key_down do |event|
      game = Game.new if event.key == 'r'
    end
  end
end

show
