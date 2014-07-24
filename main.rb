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

  def initialize(server, port)
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Squares"

    @client = Client.new(server, port)
    @board = Board.new(self)
    @error_font = Gosu::Font.new(self, "Tahoma", SCREEN_HEIGHT / 16)

    @state = :running
  end

  def update

  end

  def draw
    @board.draw

    draw_error_message if $error_message
  end

  def button_down(id)
    @board.button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  # def button_down(id)
  #   if id == Gosu::MsLeft
  #     binding.pry
  #     if within_field?(mouse_x, mouse_y)
  #       square_x = (mouse_x - @origin) / (@board_image.width / 8)
  #       square_y = (mouse_y - @origin) / (@board_image.height / 8)
  #       @orange_tiles << [square_x, square_y]
  #     end
  #   end
  # end

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
