class Game
  def initialize
    @platform = Platform.new
    @balls = [Ball.new(WIDTH / 2, HEIGHT - 25)]
    @running = true
    @level = 5
    @bricks = create_wall_of_bricks
    @last_low_brick = Time.now
    @sweets = []
    @score = 0
    @lifes = 3
    @started = false
    @last_next_level = Time.now
  end

  attr_accessor :platform, :balls, :running, :bricks, :sweets, :score, :lifes, :started, :level, :last_next_level, :last_low_brick

  def ball_hit_platform?
    @balls.each do |ball|
      if ball.y > HEIGHT - 25 && (@platform.p_left..@platform.p_left + @platform.p_size / 4).to_a.include?(ball.x.to_i)
        ball.angle -= 2
        ball.speed *= -1
      elsif ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size / 4..@platform.p_left + @platform.p_size / 2).to_a.include?(ball.x.to_i)
        ball.angle -= 1
        ball.speed *= -1
      elsif ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size / 2..@platform.p_left + @platform.p_size * 3 / 4).to_a.include?(ball.x.to_i)
        ball.angle += 1
        ball.speed *= -1
      elsif ball.y > HEIGHT - 25 && (@platform.p_left + @platform.p_size * 3 / 4..@platform.p_left + @platform.p_size).to_a.include?(ball.x.to_i)
        ball.angle += 2
        ball.speed *= -1
      end
    end
  end

  def ball_hit_top?
    @balls.each { |ball| ball.bump('verticaly') if ball.y < 10 }
  end

  def ball_hit_wall?
    @balls.each do |ball|
      ball.bump('horizontaly') if ball.x < 10 || ball.x > WIDTH - 10
    end
  end

  def ball_hit_floor?
    if @balls.empty?
      @platform = Platform.new
      return @started = false
    end
    @balls.each { |ball| @balls.delete(ball) if ball.y > HEIGHT - 10 }
  end

  def create_wall_of_bricks
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

  def ball_hit_brick?
    @balls.each do |ball|
      @bricks.each do |brick|
        if (brick.y - 10..brick.y + 30).to_a.include?(ball.y) && (brick.x..brick.x + 40).to_a.include?(ball.x.to_i)
          ball.bump('verticaly') # here ??                                                                                    <<-----<<----<<
          brick.solidity -= 1
          @bricks.delete(brick) unless brick.solidity.positive?
          @score += 10 unless brick.type == 'indestructible'
          if brick.type == 'bigger'
            @sweets << Sweet.new(brick.x + 20, brick.y + 10)
          elsif brick.type == 'double'
            @balls << Ball.new(@platform.p_right - @platform.p_size / 2, HEIGHT - 25)
          end
        elsif (brick.y..brick.y + 20).to_a.include?(ball.y) && (brick.x - 10..brick.x + 50).to_a.include?(ball.x.to_i)
          ball.bump('horizontaly')
          brick.solidity -= 1
          @bricks.delete(brick) unless brick.solidity.positive?
          @score += 10 unless brick.type == 'indestructible'
          if brick.type == 'bigger'
            @sweets << Sweet.new(brick.x + 20, brick.y + 10)
          elsif brick.type == 'double'
            @balls << Ball.new(@platform.p_right - @platform.p_size / 2, HEIGHT - 25)
          end
        end
      end
    end
  end

  def low_brick
    if Time.now - @last_low_brick > 10
      @bricks.each { |b| b.y += 10 }
      @last_low_brick = Time.now
    end
  end

  def ball_hit_sweet?
    @sweets.each do |sweet|
      next unless sweet.y > HEIGHT - 25 && (@platform.p_left..@platform.p_right).to_a.include?(sweet.x.to_i)

      @sweets.delete(sweet)
      @platform.p_size += 20
      @platform.p_left -= 10
      @platform.p_right += 10
    end
  end

  def fail?
    @running = false if @bricks.empty?
    if @balls.empty?
      @lifes -= 1
      @balls << Ball.new(WIDTH / 2, HEIGHT - 25)
      @started = false
      @platform = Platform.new
    end
  end

  def game_over?
    return if @lifes >= 0

    @running = false
  end

  def play
    Text.new("Score: #{@score}")
    Text.new("Lifes: #{@lifes}", y: 18, color: 'red')
    Text.new("LEVEL #{@level}", x: 500, color: 'orange')
    @platform.draw
    @balls.each { |ball| ball.move if @started }
    @balls.each(&:draw)
    ball_hit_platform?
    ball_hit_top?
    ball_hit_wall?
    ball_hit_floor?
    @bricks.each(&:draw)
    ball_hit_brick?
    low_brick
    @sweets.each(&:draw) unless @sweets.empty?
    @sweets.each(&:move) unless @sweets.empty?
    ball_hit_sweet?
    fail? if @started
    game_over?
  end

  def next_level
    @balls = [Ball.new(WIDTH / 2, HEIGHT - 25)]
    @level += 1
    @bricks = create_wall_of_bricks
    @running = true
    @started = false
    @platform = Platform.new
    @last_next_level = Time.now
  end
end
