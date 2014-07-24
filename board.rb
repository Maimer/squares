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
      @orange.draw(tile[0] * @orange.width + @origin,
                   tile[1] * @orange.height + @origin, 3)
    end

    @blue_tiles.each do |tile|
      @blue.draw(tile[0] * @blue.width + @origin,
                 tile[1] * @blue.height + @origin, 3)
    end
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if within_field?(@window.mouse_x, @window.mouse_y)
        square_x = ((@window.mouse_x - @origin) / (@board_image.width / 8)).to_i
        square_y = ((@window.mouse_y - @origin) / (@board_image.height / 8)).to_i
        if !@orange_tiles.include?([square_x, square_y]) || !@blue_tiles.include?([square_x, square_y])
          @orange_tiles << [square_x, square_y]
        end
      end
    end
  end

  def within_field?(x, y)
    x >= @origin && x < (@origin + @board_image.width) &&
    y >= @origin && y < (@origin + @board_image.height)
  end
end
