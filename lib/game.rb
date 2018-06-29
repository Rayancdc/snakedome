require 'gosu'
require_relative 'player.rb'
require_relative 'item.rb'

class GameWindow < Gosu::Window
  def initialize
    @player = Player.new
    @player2 = Player.new("purple")

    super 640, 480, :fullscreen => false
    self.caption = "Rayan's Snake Game"
    @background_image = Gosu::Image.new("./media/white-back.jpg", :tileable => true)


    @player.warp(416, 240)

    @player2.warp(213,240)

    @apples = Array.new
    @font = Gosu::Font.new(20)

    @player_array = [@player, @player2]
  end

  def update

    player_collision(@player, @player2)

    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player.turn_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player.turn_right
    end
    if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_UP
      @player.turn_up
    end
    if Gosu.button_down? Gosu::KB_DOWN or Gosu::button_down? Gosu::GP_DOWN
      @player.turn_down
    end

    if Gosu.button_down? Gosu::KB_A
      @player2.turn_left
    end
    if Gosu.button_down? Gosu::KB_D
      @player2.turn_right
    end
    if Gosu.button_down? Gosu::KB_W
      @player2.turn_up
    end
    if Gosu.button_down? Gosu::KB_S
      @player2.turn_down
    end

    @player_array.each do |player|
      player.die?
      player.move
      player.collect_apples(@apples)
    end

    if rand(100) < 4 and @apples.size < 100
      @apples.push(Apple.new)
    end
  end

  def player_collision(player, player2)
    player.last_position.each do |pos_hash|
      if Gosu.distance(player2.x, player2.y, pos_hash[:x], pos_hash[:y]) <= 9
        player2.die
      end
    end

    player2.last_position.each do |pos_hash|
      if Gosu.distance(player.x, player.y, pos_hash[:x], pos_hash[:y]) <= 9
        player.die
      end
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::BACKGROUND, 1, 1, Gosu::Color.argb(0xff_78AB46))
    @player.draw
    @player2.draw
    @apples.each { |apple| apple.draw }
    @font.draw("Player 1: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::GREEN)
    @font.draw("Player 2: #{@player2.score}", 10, 30, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)

    if @player.isdead
      @font.draw("PLAYER 1 LOSE. Score: #{@player.score}", 50, 120, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    end

    if @player2.isdead
      @font.draw("PLAYER 2 LOSE. Score: #{@player2.score}", 50, 360, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    end
  end

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end
end

GameWindow.new.show
