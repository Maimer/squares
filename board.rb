class Board

  attr_reader :board_image, :origin

  def initialize(window)
    @window = window
    @board_image = Gosu::Image.new(window, 'images/board_small.png')
    @orange = Gosu::Image.new(window, 'images/orange_small.png')
    @blue = Gosu::Image.new(window, 'images/blue_small.png')
    @origin = (@window.width - @board_image.width) / 2
    @orange_tiles = []
    @blue_tiles = []
  end

  def update

  end

  def draw
    @board_image.draw(@origin, @origin, 1)

    @orange_tiles.each do |tile|
      @orange.draw(tile[0] * @orange.width, tile[1] * @orange.height, 3)
    end

    @blue_tiles.each do |tile|
      @blue.draw(tile[0] * @blue.width, tile[1] * @blue.height, 3)
    end
  end
end
