class Brick
  def initialize(x, y, type, solidity)
    @x = x
    @y = y
    @type = type
    @solidity = solidity
  end

  attr_accessor :type, :x, :y, :solidity

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
                    color: '#EE82EE')
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
    elsif @type == 'indestructible'
      Rectangle.new(x: @x,
                    y: @y,
                    width: 38,
                    height: 20,
                    color: 'black')
    elsif @type == 'rock'
      if @solidity == 3
    	   Rectangle.new(x: @x,
                      y: @y,
                      width: 38,
                      height: 20,
                      color: 'red')
      elsif @solidity == 2
        Rectangle.new(x: @x,
                      y: @y,
                      width: 38,
                      height: 20,
                      color: 'orange')
      elsif @solidity == 1
        Rectangle.new(x: @x,
                      y: @y,
                      width: 38,
                      height: 20,
                      color: 'yellow')
      end
    end
  end
end
