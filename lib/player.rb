require 'gosu'

SIZE = 20

class Player
  attr_reader :x, :y, :isdead, :last_position
  def initialize(color = "green")
    @head = Gosu::Image.new("./media/green_cube.png") if color == "green"
    @body = Gosu::Image.new("./media/green_cube.png") if color == "green"
    @head = Gosu::Image.new("./media/purple_cube.png") if color == "purple"
    @body = Gosu::Image.new("./media/purple_cube.png") if color == "purple"

    @beep = Gosu::Sample.new("./media/beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @last_position = [{x: @x, y: @y}]
    @score = 0
    @size = 1
    @speed_factor = 5 + @size*1.8
    @isdead = false
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_up
    if @angle != 180
      @angle = 0
      set_speed
    end
  end

  def turn_right
    if @angle != 270
      @angle = 90
      set_speed
    end
  end

  def turn_down
    if @angle != 0
      @angle = 180
      set_speed
    end
  end

  def turn_left
    if @angle != 90
      @angle = 270
      set_speed
    end
  end

  def set_speed
    @vel_x = @speed_factor*Gosu.offset_x(@angle, 0.5)
    @vel_y = @speed_factor*Gosu.offset_y(@angle, 0.5)
  end

  def score
    @score
  end

  def collect_apples(apples)
    apples.reject! do |apple|
      if Gosu.distance(@x, @y, apple.x, apple.y) < 10
        @score += 10
        @beep.play
        @size += 1
        true
      else
        false
      end
    end
  end

  def die?
    # if (@x > 640) or (@x < 0) or (@y > 480) or (@y <0)
    #   @isdead = true
    #   @vel_x = 0
    #   @vel_y = 0
    # end

    if @last_position.size > 2
      @last_position[1..-1].each do |pos_hash|
        if Gosu.distance(@x, @y, pos_hash[:x], pos_hash[:y]) <= 5
          @isdead = true
          @vel_x = 0
          @vel_y = 0
        end
      end
    end
  end

  def die
    @isdead = true
    @vel_x = 0
    @vel_y = 0
  end

  def move
    unless @isdead
      if Gosu.distance(@x, @y, @last_position[0][:x], @last_position[0][:y]) > 9
        @last_position.unshift({x: @x, y: @y})
        @last_position = @last_position[0..@size+1]
      end
      @x += @vel_x
      @y += @vel_y
      @x %= 640
      @y %= 480

      @position = {x: @x, y: @y}
    end
  end


  def draw
    @head.draw_rot(@x, @y, 1, @angle)
    @size.times do |i|
      @body.draw_rot(@last_position[i][:x], @last_position[i][:y],1, @angle)
    end
  end
end
