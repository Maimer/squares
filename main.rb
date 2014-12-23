require 'gosu'
require 'celluloid/io'
require 'socket'
require 'randexp'

require_relative 'settings'
require_relative 'client'
require_relative 'board'
require_relative 'helpers'
require_relative 'timer'
require_relative 'square_animation'

class Main < Gosu::Window

  attr_accessor :state, :turn, :move, :orange, :blue, :orange_score, :blue_score

  def initialize(server, port)
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Squares"

    @client = Client.new(server, port)
    @board = Board.new(self)
    @timer = nil
    @error_font = Gosu::Font.new(self, "Tahoma", SCREEN_HEIGHT / 16)
    @player_font = Gosu::Font.new(self, "Tahoma", SCREEN_HEIGHT / 18)
    @gameover_font = Gosu::Font.new(self, "Tahoma", SCREEN_HEIGHT / 12)
    @state = :waiting
    @orange = "Player 1"
    @blue = "Player 2"
    @orange_score = 0
    @blue_score = 0
    @move = false
    @turn = false
    @turn_color = Gosu::Color.argb(0xffffffff)
    @not_turn_color = Gosu::Color.argb(0x99ffffff)

    @client.send_message(['join', NAME].join('|'))
  end

  def update
    @board.update

    begin
      if @state == :running && @move && @turn
        @client.send_message(['move', @move].join('|'))
        @turn = false
        @move = false
      else
        @client.send_message('wait')
        @move = false
      end

      if data = @client.read_message
        data = data.split('|')
        if data && !data.empty?
          if data[0] == "waiting"
            @state = :waiting
            @orange = "Player 1"
            @blue = "Player 2"
            @orange_score = 0
            @blue_score = 0
            @move = false
            @turn = false
            @board.tiles = []
            @board.square_animations = []
          elsif data[0] == "game"
            if @state != :gameover
              @state = :running
              @orange = data[1]
              @blue = data[2]
              @orange_score = data[3]
              @blue_score = data[4]
              if !data[5].nil?
                @board.tiles = []
                data[5..-1].each do |tile|
                  @board.tiles << tile
                end
              end
            end
            if (@orange_score.to_i >= 150 || @blue_score.to_i >= 150) &&
               (@orange_score.to_i - @blue_score.to_i).abs > 15
              @turn = false
              @state = :gameover
              if @timer == nil
                @timer = Timer.new
              else
                @timer.update
                if @timer.seconds > 15
                  close
                end
              end
            else
              if (@board.tiles.size % 2 == 0 && @orange == NAME) || (@board.tiles.size % 2 != 0 && @blue == NAME)
                @turn = true
              else
                @turn = false
              end
            end
          end
        end
      end
    rescue
    end
  end

  def draw
    draw_quad(0, 0, Gosu::Color::BLACK,
              SCREEN_WIDTH, 0, Gosu::Color::BLACK,
              SCREEN_WIDTH, SCREEN_HEIGHT, 0xFF555555,
              0, SCREEN_HEIGHT, 0xFF555555, 0)

    @board.draw

    @board.orange.draw(@board.origin, @board.board_image.height + @board.origin * 1.5 + 10, 3)
    @board.blue.draw(@board.origin, @board.board_image.height + @board.origin * 3 + @error_font.height, 3)

    if @turn && @state == :running
      my_color = @turn_color
      opponent_color = @not_turn_color
    elsif @state == :running
      my_color = @not_turn_color
      opponent_color = @turn_color
    end

    if @orange == NAME && @state == :running
      color1 = my_color
      color2 = opponent_color
    elsif @blue == NAME && @state == :running
      color1 = opponent_color
      color2 = my_color
    else
      color1 = @not_turn_color
      color2 = @not_turn_color
    end

    if @state == :gameover
      if (@orange_score.to_i > @blue_score.to_i && @orange == NAME) ||
         (@blue_score.to_i > @orange_score.to_i && @blue == NAME)
        message = "You Win!"
      else
        message = "You Lose!"
      end

      Drawing::draw_text(Drawing::text_center(self, message, @gameover_font),
                         @board.board_image.height / 2 + @board.origin / 2 - @gameover_font.height / 2,
                         message,
                         @gameover_font,
                         Gosu::Color::RED)
      Drawing::draw_rect(self,
                         @board.origin,
                         @board.origin,
                         @board.board_image.width,
                         @board.board_image.height,
                         0x77000000)
    end

    Drawing::draw_text(@board.origin + @board.orange.width,
                       @board.board_image.height + @board.origin * 1.5 + 10,
                       "#{@orange}",
                       @player_font,
                       color1)

    Drawing::draw_text(SCREEN_WIDTH - 64 - @player_font.text_width("#{@orange_score}"),
                       @board.board_image.height + @board.origin * 1.5 + 10,
                       "#{@orange_score}",
                       @player_font,
                       color1)

    Drawing::draw_rect(self,
                       @board.origin + @board.orange.width,
                       @board.board_image.height + @board.origin * 2 + 40,
                       @orange_score.to_i < 150 ? @orange_score.to_i * 2.5 : 375,
                       10,
                       0xFFff5b00)

    coords = [@board.origin + @board.orange.width,
              @board.board_image.height + @board.origin * 2 + 40]

    draw_line(coords[0], coords[1], Gosu::Color::WHITE, coords[0]+375, coords[1], Gosu::Color::WHITE, 11)
    draw_line(coords[0]+375, coords[1], Gosu::Color::WHITE, coords[0]+375, coords[1]+10, Gosu::Color::WHITE, 11)
    draw_line(coords[0], coords[1]+10, Gosu::Color::WHITE, coords[0]+375, coords[1]+10, Gosu::Color::WHITE, 11)
    draw_line(coords[0], coords[1], Gosu::Color::WHITE, coords[0], coords[1]+10, Gosu::Color::WHITE, 11)

    Drawing::draw_text(@board.origin + @board.blue.width,
                       @board.board_image.height + @board.origin * 3 + @error_font.height,
                       "#{@blue}",
                       @player_font,
                       color2)

    Drawing::draw_text(SCREEN_WIDTH - 64 - @player_font.text_width("#{@blue_score}"),
                       @board.board_image.height + @board.origin * 3 + @error_font.height,
                       "#{@blue_score}",
                       @player_font,
                       color2)

    Drawing::draw_rect(self,
                       @board.origin + @board.orange.width,
                       @board.board_image.height + @board.origin * 3 + @error_font.height + 40,
                       @blue_score.to_i < 150 ? @blue_score.to_i * 2.5 : 375,
                       10,
                       0xFF002bff)

    coords = [@board.origin + @board.orange.width,
              @board.board_image.height + @board.origin * 3 + @error_font.height + 40]

    draw_line(coords[0], coords[1], Gosu::Color::WHITE, coords[0]+375, coords[1], Gosu::Color::WHITE, 11)
    draw_line(coords[0]+375, coords[1], Gosu::Color::WHITE, coords[0]+375, coords[1]+10, Gosu::Color::WHITE, 11)
    draw_line(coords[0], coords[1]+10, Gosu::Color::WHITE, coords[0]+375, coords[1]+10, Gosu::Color::WHITE, 11)
    draw_line(coords[0], coords[1], Gosu::Color::WHITE, coords[0], coords[1]+10, Gosu::Color::WHITE, 11)

    draw_error_message if $error_message
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if within_field?(mouse_x, mouse_y) && @turn
        square_x = ((mouse_x - @board.origin) / (@board.board_image.width / 8)).to_i
        square_y = ((mouse_y - @board.origin) / (@board.board_image.height / 8)).to_i
        tile = square_y * 8 + square_x
        if NAME == @orange
          color = "O"
        else
          color = "B"
        end
        if !@board.tiles.include?("O" + tile.to_s) && !@board.tiles.include?("B" + tile.to_s)
          @move = [square_x, square_y]
        end
      end
    end
    if id == Gosu::KbEscape
      close
    end
  end

  def within_field?(x, y)
    x >= @board.origin && x < (@board.origin + @board.board_image.width) &&
    y >= @board.origin && y < (@board.origin + @board.board_image.height)
  end

  def needs_cursor?
    true
  end

  def draw_error_message
    Drawing::draw_text(Drawing::text_center(self, $error_message, @error_font),
                       @board.board_image.height / 2 + @board.origin / 2 - @error_font.height / 2,
                       $error_message,
                       @error_font,
                       Gosu::Color::RED)
  end

end

Main.new(SERVER, PORT).show
