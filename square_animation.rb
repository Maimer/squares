class SquareAnimation

  def initialize(window, p1, p2, p3, p4, color, board)
    @window = window
    @board = board
    @message = "+#{([p1[0], p2[0], p3[0], p4[0]].max - [p1[0], p2[0], p3[0], p4[0]].min + 1) ** 2}"
    @score_font = Gosu::Font.new(window, "Tahoma", SCREEN_HEIGHT / 16)
    @p1 = [p1[0] * @board.orange.width + (@board.orange.width / 2) + @board.origin,
           p1[1] * @board.orange.height + (@board.orange.height / 2) + @board.origin]
    @p2 = [p2[0] * @board.orange.width + (@board.orange.width / 2) + @board.origin,
           p2[1] * @board.orange.height + (@board.orange.height / 2) + @board.origin]
    @p3 = [p3[0] * @board.orange.width + (@board.orange.width / 2) + @board.origin,
           p3[1] * @board.orange.height + (@board.orange.height / 2) + @board.origin]
    @p4 = [p4[0] * @board.orange.width + (@board.orange.width / 2) + @board.origin,
           p4[1] * @board.orange.height + (@board.orange.height / 2) + @board.origin]
    color == "O" ? @color = Gosu::Color.argb(100, 255, 91, 0) : @color = Gosu::Color.argb(100, 0, 43, 255)
    @font_color = Gosu::Color.argb(255, 255, 255, 255)
    @time = Gosu::milliseconds
  end

  def update
    if Gosu::milliseconds - @time > 1500
      alpha = (100 - ((Gosu::milliseconds - @time - 1500) / 20))
      font_alpha = (255 - ((Gosu::milliseconds - @time - 1500) / 8))
      if alpha < 0 then alpha = 0 end
      if font_alpha < 0 then font_alpha = 0 end
      @color.alpha = alpha
      @font_color.alpha = font_alpha
    end
  end

  def draw
    if @color.alpha > 0
      square_x = ([@p1[0], @p2[0], @p3[0], @p4[0]].max + [@p1[0], @p2[0], @p3[0], @p4[0]].min) / 2
      square_y = ([@p1[1], @p2[1], @p3[1], @p4[1]].max + [@p1[1], @p2[1], @p3[1], @p4[1]].min) / 2
      Drawing::draw_text(square_x - @score_font.text_width(@message) / 2,
                         square_y - @score_font.height / 2 - 5,
                         @message,
                         @score_font,
                         @font_color)
    @window.draw_quad(@p1[0], @p1[1], @color,
                      @p2[0], @p2[1], @color,
                      @p3[0], @p3[1], @color,
                      @p4[0], @p4[1], @color, 1)
    end
  end
end
