require './brick.rb'

class Wall
  def initialize(level)
    @level = level
    @bricks = build
  end

  attr_accessor :level, :bricks

    def build
      bricks = []
      if @level == 1
      x = 40
      y = 40
      2.times do
        bricks << Brick.new(x, y, 'bigger', 1)
        x += 40
        11.times do
          bricks << Brick.new(x, y, 'regular', 1)
          x += 40
        end
        bricks << Brick.new(x, y, 'bigger', 1)
        y += 66
        x = 40
      end
      x = 40
      y = 62
      2.times do
        4.times do
          bricks << Brick.new(x, y, 'regular', 1)
          x += 40
        end
        bricks << Brick.new(x, y, 'double', 1)
        x += 40
        3.times do
          bricks << Brick.new(x, y, 'regular', 1)
          x += 40
        end
        bricks << Brick.new(x, y, 'double', 1)
        x += 40
        4.times do
          bricks << Brick.new(x, y, 'regular', 1)
          x += 40
        end
        y += 22
        x = 40
      end
    elsif @level == 2
      x = 40
      y = 40
      4.times do
        13.times do
          bricks << Brick.new(x, y, 'double', 1)
          x += 40
        end
        y += 22
        x = 40
      end
    elsif @level == 3
      x = 80
      y = 40
      2.times do
        z = -1
        11.times do
          z.positive? ? bricks << Brick.new(x, y, 'regular', 1) : bricks << Brick.new(x, y, 'double', 1)
          x += 40
          z = -z
        end
        y += 66
        x = 80
      end
      start = -10
      x = -20
      y = 128
      3.times do
        15.times do
          bricks << Brick.new(x, y, 'regular', 1)
          x += 40
        end
        y += 22
        start += 10
        x = start
      end
    elsif @level == 4
      x = 0
      y = 100
      15.times do
        bricks << Brick.new(x, y, 'rock', 3)
        x += 40
      end
      x = 180
      y = 78
      5.times do
        bricks << Brick.new(x, y, 'double', 1)
        x += 40
      end
      x = 42
      y = 122
      13.times do
        bricks << Brick.new(x, y, 'regular', 1)
        x += 40
      end
      bricks << Brick.new(0, 122, 'bigger', 1)
      bricks << Brick.new(WIDTH - 40, 122, 'bigger', 1)
    elsif @level == 5
      x = 0
      y = 150
      6.times do
        bricks << Brick.new(x, y, 'rock', 3)
        x += 40
      end
      x = WIDTH - 6 * 40
      6.times do
        bricks << Brick.new(x, y, 'rock', 3)
        x += 40
      end
      x = 5 * 40
      y = 128
      4.times do
        bricks << Brick.new(x, y, 'indestructible', 9999)
        y -= 22
      end
      x = WIDTH - 6 * 40
      y = 128
      4.times do
        bricks << Brick.new(x, y, 'indestructible', 9999)
        y -= 22
      end
      x = WIDTH - 5 * 40
      y = 128
      3.times do
        5.times do
          bricks << Brick.new(x, y, 'regular', 1)
          x += 40
        end
        x = WIDTH - 5 * 40
        y -= 22
      end
      x = 0
      y = 128
      3.times do
        5.times do
          bricks << Brick.new(x, y, 'regular', 1)
          x += 40
        end
        x = 0
        y -= 22
      end
      x = WIDTH - 5 * 40
      y = 62
      5.times do
        bricks << Brick.new(x, y, 'double', 1)
        x += 40
      end
      x = 0
      y = 62
      5.times do
        bricks << Brick.new(x, y, 'double', 1)
        x += 40
      end
    end
    bricks
  end

end
