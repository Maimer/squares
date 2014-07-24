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

  def button_down(key)
    if key == Gosu::MsLeft

    end
    if key == Gosu::KbEscape
      close
    end
  end

  def needs_cursor?
    true
  end

  def draw_error_message
    Drawing::draw_text(Drawing::text_center(self, $error_message, @error_font),
                       SCREEN_HEIGHT / 2,
                       $error_message,
                       @error_font,
                       Gosu::Color::RED)
  end

end

Main.new(SERVER, PORT).show
