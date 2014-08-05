class Board

  attr_reader :board_image, :origin, :orange, :blue
  attr_accessor :tiles

  def initialize(window)
    @window = window
    @board_image = Gosu::Image.new(window, 'images/board_small.png')
    @orange = Gosu::Image.new(window, 'images/orange_small.png')
    @blue = Gosu::Image.new(window, 'images/blue_small.png')
    @origin = (@window.width - @board_image.width) / 2
    @tiles = []
    @squares = []
    @tiles_size = 0
  end

  def update
    if @tiles_size < @tiles.size
      update_squares()
      @tiles_size = @tiles.size
    elsif @tiles_size > @tiles.size
      @squares = []
      @tiles_size = 0
    end
  end

  def draw
    @board_image.draw(@origin, @origin, 1)

    @tiles.each do |tile|
      col = tile[1..-1].to_i / 8
      row = tile[1..-1].to_i % 8
      if tile.start_with?('O')
        @orange.draw(row * @orange.width + @origin,
                   col * @orange.height + @origin, 3)
      else
        @blue.draw(row * @blue.width + @origin,
                 col * @blue.height + @origin, 3)
      end
    end

    @squares.each do |square|
      square[0] == "O" ? color = Gosu::Color.argb(0xFFff5b00) : color = Gosu::Color.argb(0xFF002bff)
      4.times do |i|
        s = square[1..-1].rotate(i)
        x1 = s[0][0] * @orange.width + (@orange.width / 2) + @origin
        y1 = s[0][1] * @orange.height + (@orange.width / 2) + @origin
        x2 = s[1][0] * @orange.width + (@orange.width / 2) + @origin
        y2 = s[1][1] * @orange.height + (@orange.width / 2) + @origin
        @window.draw_line(x1, y1, color, x2, y2, color, 2)
        # @window.draw_quad(x1, y1+10, color,
        #                   x2, y2+10, color,
        #                   x1, y1-10, color,
        #                   x2, y2-10, color, 2)
      end
    end
  end

  def update_squares
    color = @tiles.last[0]
    pieces = @tiles.reject { |tile| !tile.start_with?(color) }
    pieces.map! { |tile| [tile[1..-1].to_i % 8, tile[1..-1].to_i / 8] }
    last = pieces.pop
    score = 0

    pieces.each do |tile|
      diff_x = tile[0] - last[0]
      diff_y = tile[1] - last[1]
      if pieces.include?([tile[0] - diff_y, tile[1] + diff_x]) &&
         pieces.include?([last[0] - diff_y, last[1] + diff_x])
         @squares << [color, last, tile,
                     [tile[0] - diff_y, tile[1] + diff_x],
                     [last[0] - diff_y, last[1] + diff_x]]
      end
    end
  end
end
