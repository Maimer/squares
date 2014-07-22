require 'gosu'
require 'celluloid/io'
require 'socket'
require 'randexp'
require 'pry'

require_relative 'settings'
require_relative 'client'

class Main < Gosu::Window

  def initialize(server, port)
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Squares"

    @client = Client.new(server, port)

    @state = :running
  end

  def update

  end

  def draw

    draw_error_message if $error_message
  end

  def button_down(key)
    if key == Gosu::MsLeft

    end
    if key == Gosu::KbEscape
      close
    end
  end

  def draw_error_message

  end

end

Main.new(SERVER, PORT).show
