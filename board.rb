class Board

  def initialize(window)
    @window = window
    @board = Gosu::Image.new(window, 'images/board_small.png')
    @orange = Gosu::Image.new(window, 'images/orange_small.png')
    @blue = Gosu::Image.new(window, 'images/blue_small.png')
    @origin = (@window.width - (@tile.width * 8)) / 2
    @orange_tiles = []
    @blue_tiles = []
  end

  def update

  end

  def draw
    @board.draw(@origin, @origin, 1)
  end
end
