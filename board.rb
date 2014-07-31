class Board

  attr_reader :board_image, :origin
  attr_accessor :tiles

  def initialize(window)
    @window = window
    @board_image = Gosu::Image.new(window, 'images/board_small.png')
    @orange = Gosu::Image.new(window, 'images/orange_small.png')
    @blue = Gosu::Image.new(window, 'images/blue_small.png')
    @origin = (@window.width - @board_image.width) / 2
    @tiles = []
  end

  def update

  end

  def draw
    @board_image.draw(@origin, @origin, 1)

    @tiles.each do |tile|
      col = tile[1..-1].to_i / 8 + 1
      row = tile[1..-1].to_i % 8 + 1
      if tile.start_with?('O')
        @orange.draw(row * @orange.width + @origin,
                   col * @orange.height + @origin, 3)
      else
        @blue.draw(row * @blue.width + @origin,
                 col * @blue.height + @origin, 3)
      end
    end
  end
end
