require 'gosu'
require 'celluloid/io'
require 'socket'
require 'randexp'
require 'pry'

require_relative 'settings'
require_relative 'client'
require_relative 'board'
require_relative 'helpers'

class Main < Gosu::Window

  attr_accessor :state, :turn, :move, :orange, :blue

  def initialize(server, port)
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Squares"

    @client = Client.new(server, port)
    @board = Board.new(self)
    @error_font = Gosu::Font.new(self, "Tahoma", SCREEN_HEIGHT / 16)
    @state = :waiting
    @orange = ""
    @blue = ""
    @move = false
    @turn = false

    @client.send_message(['join', NAME].join('|'))
  end

  def update
    if data = @client.read_message
      data = data.split('|')
      if data && !data.empty?

        #update board, score, opponent name, state, turn
      end
    end

    if @move && @turn
      @client.send_message(['move', square_x, square_y].join('|'))
    else
      @client.send_message('wait')
    end
  end

  def draw
    @board.draw

    draw_error_message if $error_message
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if within_field?(@window.mouse_x, @window.mouse_y)
        square_x = ((@window.mouse_x - @origin) / (@board_image.width / 8)).to_i
        square_y = ((@window.mouse_y - @origin) / (@board_image.height / 8)).to_i
        if !@board.orange_tiles.include?([square_x, square_y]) || !@board.blue_tiles.include?([square_x, square_y])
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
