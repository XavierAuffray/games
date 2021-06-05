require './ball.rb'
require './platform.rb'
require './brick.rb'
require './sweet.rb'
require './game.rb'
require 'ruby2d'
require 'time'

set background: 'blue'
set fps_cap: 100
set width: 600
set height: 600
WIDTH = get :width
HEIGHT = get :height

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
