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
