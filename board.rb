class Board

  attr_reader :board_image, :origin, :orange, :blue
  attr_accessor :tiles, :square_animations

  def initialize(window)
    @window = window
    @board_image = Gosu::Image.new(window, 'images/board_small.png')
    @border = Gosu::Image.new(window, 'images/border_small1.png')
    @orange = Gosu::Image.new(window, 'images/orange_small.png')
    @blue = Gosu::Image.new(window, 'images/blue_small.png')
    @orange_glow = Gosu::Image.new(window, 'images/orange_glow.png')
    @blue_glow = Gosu::Image.new(window, 'images/blue_glow.png')
    @origin = (@window.width - @board_image.width) / 2
    @tiles = []
    @squares = []
    @square_animations = []
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
    @square_animations.each { |anim| anim.update }
  end

  def draw
    @border.draw(@origin - 10, @origin - 10, 1)

    @tiles.each do |tile|
      col = tile[1..-1].to_i / 8
      row = tile[1..-1].to_i % 8
      if tile.start_with?('O')
        @orange.draw(row * @orange.width + @origin,
                     col * @orange.height + @origin, 3)
        if tile == @tiles.last
          @orange_glow.draw(row * @orange.width + @origin + 4,
                            col * @orange.height + @origin + 4, 2)
        end
      else
        @blue.draw(row * @blue.width + @origin,
                   col * @blue.height + @origin, 3)
        if tile == @tiles.last
          @blue_glow.draw(row * @blue.width + @origin + 4,
                          col * @blue.height + @origin + 4, 2)
        end
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
      end
    end

    @square_animations.each { |anim| anim.draw }
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
         @square_animations << SquareAnimation.new(@window, last, tile,
                                                  [tile[0] - diff_y, tile[1] + diff_x],
                                                  [last[0] - diff_y, last[1] + diff_x],
                                                  color, self)
      end
    end
  end
end
