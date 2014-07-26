require 'gosu'
require 'celluloid/io'
require 'socket'
require 'randexp'
require 'securerandom'
require 'pry'

require_relative 'settings'
require_relative 'client'
require_relative 'board'
require_relative 'helpers'

class Main < Gosu::Window

  def initialize(server, port)
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Squares"

    @uuid = SecureRandom.uuid

    @client = Client.new(server, port)
    @board = Board.new(self)
    @error_font = Gosu::Font.new(self, "Tahoma", SCREEN_HEIGHT / 16)
    @state = :running

    @client.send_message(['join', NAME, @uuid].join("|"))
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
