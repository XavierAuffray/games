class Ball
  def initialize(x, y, angle = rand(-5.0..5.0))
    @x = x
    @y = y
    @angle = angle
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
