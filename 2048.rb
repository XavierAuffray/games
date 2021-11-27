require 'ruby2d'
require 'time'

set background: '#bbada0'
set fps_cap: 100
set width: 800
set height: 800
WIDTH = get :width
HEIGHT = get :height
VAL = WIDTH / 4





class Number
  def initialize(x, y)
    @x = x
    @y = y
    @value = [2, 4].sample
  end

  attr_accessor :x, :y, :value

  def draw
    if @value == 4
      Square.new(x: @x * VAL + 10, y: @y * VAL + 10, size: VAL - 20, color: 'red')
      Text.new('4', x: @x * VAL + 20 + VAL / 3, y: @y * VAL + 10 + VAL / 3, size: 60, color: 'white')
    elsif @value == 2
      Square.new(x: @x * VAL + 10, y: @y * VAL + 10, size: VAL - 20, color: 'blue')
      Text.new('2', x: @x * VAL + 20 + VAL / 3, y: @y * VAL + 10 + VAL / 3, size: 60, color: 'white')
    end
  end

  def move(direction, numbers)
    if direction == 'up'
      @y -= (@y - numbers.select { |n| n.x == @x && n.y < @y }.count)
    elsif direction == 'down'
      @y += (3 - @y - numbers.select { |n| n.x == @x && n.y > @y }.count)
    elsif direction == 'left'
      @x -= (@x - numbers.select { |n| n.y == @y && n.x > @x }.count)
    elsif direction == 'right'
      @x += (3 - @x - numbers.select { |n| n.y == @y && n.x > @x }.count)
    end
  end

  def can_move?(direction, numbers)
    if direction == 'up'
      (numbers.select { |n| n.x == @x && n.y < @y }.count - @y) != 0
    elsif direction == 'down'
      (3 - numbers.select { |n| n.x == @x && n.y > @y }.count - @y) != 0
    elsif direction == 'left'
      (numbers.select { |n| n.y == @y && n.x < @x }.count - @x) != 0
    elsif direction == 'right'
      (3 - numbers.select { |n| n.y == @y && n.x > @x }.count - @x) != 0
    end
  end

  def can_merge?(direction, numbers)
    if direction == 'up' && numbers.select { |n| n.x == @x && n.y == @y - 1 }.first&.value == @value
      numbers.each do |n|
        if !can_move?(direction, numbers) && n.x == @x && n.y == @y - 1
          @value *= 2
          numbers.delete(self)
        end
      end
    # elsif direction == 'down'
    #   numbers.select { |n| n.x == @x && n.y == @y + 1 }.first&.value == @value
    # elsif direction == 'left'
    #   numbers.select { |n| n.y == @y && n.x == @x - 1 }.first&.value == @value
    # elsif direction == 'right'
    #   numbers.select { |n| n.y == @y && n.x == @x + 1 }.first&.value == @value
    end
  end
end





class Game
  def initialize
    @numbers = initalize_numbers
    @last_move = Time.now
  end

  attr_accessor :numbers, :board, :last_move

  def initalize_numbers
    @numbers = []
    @numbers << Number.new(rand(3), rand(3))
    coord = assign_position
    @numbers << Number.new(coord[0], coord[1])
    coord = assign_position
    @numbers << Number.new(coord[0], coord[1])
  end

  def assign_position
    x = rand(3)
    y = rand(3)
    x_set = @numbers.map(&:x)
    y_set = @numbers.map(&:y)
    while x_set.include?(x) && y_set.include?(y)
      x = rand(3)
      y = rand(3)
    end
    [x, y]
  end

  def draw_board
    ix = 10
    igreq = 10

    4.times do
      4.times do
        Square.new(x: ix, y: igreq, size: VAL - 20, color: '#cdc0b4')
        igreq += VAL
      end
      igreq = 10
      ix += VAL
    end
  end

  def move_once
    Time.now - @last_move > 0.1
  end

  def new_number
    coord = assign_position
    @numbers << Number.new(coord[0], coord[1])
  end
end

game = Game.new
update do
  clear
  game.draw_board
  game.numbers.each(&:draw)
  on :key_down do |event|
    if event.key == 'up' && game.move_once
      temp = game.numbers.sort_by(&:y)
      temp.each { |n| n.move(event.key, temp) }
      # temp.each { |n| n.can_merge?(event.key, temp) }
      game.last_move = Time.now
      game.new_number unless game.numbers.sort_by(&:y) == temp.sort_by(&:y)
    elsif event.key == 'down' && game.move_once
      temp = game.numbers.sort_by { |n| -n.y }
      temp.each { |n| n.move(event.key, temp) }
      # temp.each { |n| n.can_merge?(event.key, temp) }
      game.last_move = Time.now
      game.new_number unless game.numbers.sort_by(&:y) == temp.sort_by(&:y)
    elsif event.key == 'left' && game.move_once
      temp = game.numbers.sort_by(&:x)
      temp.each { |n| n.move(event.key, temp) }
      # temp.each { |n| n.can_merge?(event.key, temp) }
      game.last_move = Time.now
      game.new_number unless game.numbers.sort_by(&:x) == temp.sort_by(&:x)
    elsif event.key == 'right' && game.move_once
      temp = game.numbers.sort_by { |n| -n.x }
      temp.each { |n| n.move(event.key, temp) }
      # game.numbers.each { |n| n.can_merge?(event.key, game.numbers) }
      game.last_move = Time.now
      game.new_number unless game.numbers.sort_by(&:x) == temp.sort_by(&:x)
    end
  end
end

show
