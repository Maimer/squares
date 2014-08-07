require 'gosu'
require 'celluloid/io'
require 'socket'
require 'randexp'
require 'pry'

require_relative 'settings'
require_relative 'client'
require_relative 'board'
require_relative 'helpers'
require_relative 'timer'

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
          elsif data[0] == "game"
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
            if @orange_score < 150 && @blue_score < 150
              if (@board.tiles.size % 2 == 0 && @orange == NAME) || (@board.tiles.size % 2 != 0 && @blue == NAME)
                @turn = true
              else
                @turn = false
              end
            else
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
            end
          end
        end
      end
    rescue
    end
  end

  def draw
    @board.draw

    @board.orange.draw(@board.origin, @board.board_image.height + @board.origin * 1.5, 3)
    @board.blue.draw(@board.origin, @board.board_image.height + @board.origin * 3 + @error_font.height, 3)

    if @turn && @state == :running
      my_color = @turn_color
      opponent_color = @not_turn_color
    elsif @state == :running
      my_color = @not_turn_color
      opponent_color = @turn_color
    end

    if @orange == NAME
      color1 = my_color
      color2 = opponent_color
    elsif @blue == NAME
      color1 = opponent_color
      color2 = my_color
    else
      color1 = @not_turn_color
      color2 = @not_turn_color
    end

    Drawing::draw_text(@board.origin + @board.orange.width,
                       @board.board_image.height + @board.origin * 1.5,
                       "#{@orange}: #{@orange_score}",
                       @player_font,
                       color1)

    Drawing::draw_text(@board.origin + @board.blue.width,
                       @board.board_image.height + @board.origin * 3 + @error_font.height,
                       "#{@blue}: #{@blue_score}",
                       @player_font,
                       color2)

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
        if !@board.tiles.include?(color + tile.to_s)
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
