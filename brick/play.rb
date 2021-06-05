require './ball.rb'
require './wall.rb'
require './platform.rb'
require './brick.rb'
require './sweet.rb'
require './game.rb'
require './arrow.rb'
require 'ruby2d'
require 'time'

set background: 'blue'
set fps_cap: 200
set width: 600
set height: 600
WIDTH = get :width
HEIGHT = get :height

game = Game.new

update do
   clear
  if game.running
    game.play
    unless game.started
      Text.new("Press 'space' to start", x: 60, y: HEIGHT / 2, size: 50)
      game.arrow.draw
      on :key_held do |event|
        game.arrow.move(event.key) if (event.key == 'right' || event.key == 'left')
      end
    end
    on :key_held do |event|
      game.platform.move(event.key) if (event.key == 'left' || event.key == 'right') && game.platform.can_move? && game.started
      if event.key == 'space'
        game.started = true
        game.balls.first.angle = ((300 - game.arrow.x2) / 10) * -1
      end
    end
  elsif game.lifes >= 0
    Text.new("Level #{game.level} completed",
             x: 40,
             y: 200,
             size: 60)
    Text.new("press 'n' for next stage",
             x: 100,
             y: 300,
             size: 30)
    on :key_down do |event|
      game.next_level if event.key == 'n'  if Time.now - game.last_next_level > 0.1
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
