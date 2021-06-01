require 'ruby2d'

set background: 'blue'
set fps_cap: 5
set width: 600
set height: 400
WIDTH = get :width
HEIGHT = get :height
WIDTH_VALUE = 30
HEIGHT_VALUE = 20
GRID_WIDTH = WIDTH / WIDTH_VALUE
GRID_HEIGTH = HEIGHT / HEIGHT_VALUE


class Snake
  def initialize
    @running = true
    @positions = [[2, 2], [3, 2], [4, 2]]
    @direction = 'right'
    @sweet_position = set_sweet_position
    @score = 0
    @collision = false
  end

  attr_accessor :positions, :direction, :running, :sweet_position, :score

  def draw
    positions.each do |position|
      Square.new(x: position.first * GRID_WIDTH,
                 y: position.last * GRID_HEIGTH,
                 size: 18,
                 color: 'green')
    end
  end

  def draw_sweet
    Circle.new(x: sweet_position.first * GRID_WIDTH + 9,
               y: sweet_position.last * GRID_HEIGTH + 9,
               radius: 10,
               color: 'yellow')
  end

  def move_to(direction)
    case direction
    when 'right' then @positions.insert(0, [@positions[0][0] + 1, @positions[0][1]])
    when 'left' then @positions.insert(0, [@positions[0][0] - 1, @positions[0][1]])
    when 'top' then @positions.insert(0, [@positions[0][0], @positions[0][1] - 1])
    when 'bottom' then @positions.insert(0, [@positions[0][0], @positions[0][1] + 1])
    end
    @positions.pop unless @collision
    @collision = false
  end

  def move
    case @direction
    when 'right' then move_to('right')
    when 'left' then move_to('left')
    when 'top' then move_to('top')
    when 'bottom' then move_to('bottom')
    end
  end

  def set_sweet_position
    x = rand(0..29)
    x = rand(0..29) while positions.map(&:first).include?(x)
    y = rand(0..19)
    y = rand(0..19) while positions.map(&:last).include?(y)
    [x, y]
  end

  def detect_collision_sweet
    if positions.first == sweet_position
      @sweet_position = set_sweet_position
      @score += 1
      @collision = true
    end
  end

  def new_apparition(location)
    @positions.insert(0, [@positions.first.first + WIDTH_VALUE - 1, @positions[0][1]]) if location == 'left'
    @positions.insert(0, [@positions.first.first - WIDTH_VALUE, @positions[0][1]]) if location == 'right'
    @positions.insert(0, [@positions.first.first, @positions[0][1] + HEIGHT_VALUE - 1]) if location == 'top'
    @positions.insert(0, [@positions.first.first, @positions[0][1] - HEIGHT_VALUE]) if location == 'bottom'
    @positions.pop
  end

  def detect_wall_collision
    new_apparition('left') if @positions.first.first == 0
    new_apparition('right') if @positions.first.first == 30
    new_apparition('top') if @positions.first.last == 0
    new_apparition('bottom') if @positions.first.last == 20
  end
end

snake = Snake.new
best_score = 0

update do
  on :key_down do |event|
    snake.direction = 'top' if event.key == 'up' && snake.direction != 'bottom'
    snake.direction = 'bottom' if event.key == 'down' && snake.direction != 'top'
    snake.direction = 'left' if event.key == 'left' && snake.direction != 'right'
    snake.direction = 'right' if event.key == 'right' && snake.direction != 'left'
  end

  clear
  if snake.running
    Text.new("Score: #{snake.score}")
    Text.new("Best Score: #{best_score}", y: 20)
  else
    Text.new("Final Score: #{snake.score}", x: 150, y: 150, size: 50)
    Text.new("Best Score: #{best_score}", x: 150, y: 200, size: 30)
    Text.new("press 'r' to restart", x: 150, y: 250, size: 20)
    on :key_down do |event|
      snake = Snake.new if event.key == 'r'
    end
  end
  snake.draw if snake.running
  snake.draw_sweet
  snake.move
  snake.detect_collision_sweet
  snake.detect_wall_collision
  if snake.positions.uniq.count != snake.positions.count && snake.positions.count != 3
    snake.running = false
    best_score = snake.score if snake.score > best_score
  end
end

show
