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
    if direction == 'left' && can_move?(direction)
      @x2 -= 1
      @x2 < WIDTH / 2 ? @y2 += 0.25 : @y2 -= 0.25
    elsif direction == 'right' && can_move?(direction)
      @x2 += 1
      @x2 < WIDTH / 2 ? @y2 -= 0.25 : @y2 += 0.25
    end
  end

  def can_move?(direction)
  	return unless Time.now - @last_move > 0.0001

    @last_move = Time.now
    case direction
    when 'left' then return (300 - @x2) / 10 < 5
    when 'right' then return (300 - @x2) / 10 > -5
    end
  end
end
