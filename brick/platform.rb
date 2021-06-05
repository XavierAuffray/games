class Platform
  def initialize
    @p_size = 80
    @p_left = WIDTH / 2 - @p_size / 2
    @p_right = WIDTH / 2 + @p_size / 2
    @last_move = Time.now
    @grow = 0
  end

  attr_accessor :p_size, :p_left, :p_right, :grow

  def draw
    Line.new(x1: @p_left - @grow / 2,
             y1: HEIGHT - 10,
             x2: @p_right + @grow / 2,
             y2: HEIGHT - 10,
             width: 10)
  end

  def move(direction)
    if direction == 'left'
      if @p_left.positive?
        @p_left -= 5
        @p_right -= 5
      end
    end
    if direction == 'right'
      if @p_right < WIDTH
        @p_left += 5
        @p_right += 5
      end
    end
    @last_move = Time.now
  end

  def can_move?
    Time.now - @last_move > 0.005
  end
end
