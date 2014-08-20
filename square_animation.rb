class SquareAnimation

  def initialize(window, p1, p2, p3, p4, color, board)
    @window = window
    @board = board
    @p1 = [p1[0] * @board.orange.width + (@board.orange.width / 2) + @board.origin,
           p1[1] * @board.orange.height + (@board.orange.width / 2) + @board.origin]
    @p2 = [p2[0] * @board.orange.width + (@board.orange.width / 2) + @board.origin,
           p2[1] * @board.orange.height + (@board.orange.width / 2) + @board.origin]
    @p3 = [p3[0] * @board.orange.width + (@board.orange.width / 2) + @board.origin,
           p3[1] * @board.orange.height + (@board.orange.width / 2) + @board.origin]
    @p4 = [p4[0] * @board.orange.width + (@board.orange.width / 2) + @board.origin,
           p4[1] * @board.orange.height + (@board.orange.width / 2) + @board.origin]
    @c = color
    color == "O" ? @color = Gosu::Color.argb(119, 255, 91, 0) : @color = Gosu::Color.argb(119, 0, 43, 255)
    @time = Gosu::milliseconds
  end

  def update
    if Gosu::milliseconds - @time > 1500
      alpha = (119 - ((Gosu::milliseconds - @time - 1500) / 20))
      if alpha < 0 then alpha = 0 end
      if @c == "O"
        @color = Gosu::Color.argb(alpha, 255, 91, 0)
      else
        @color = Gosu::Color.argb(alpha, 0, 43, 255)
      end
    end
  end

  def draw
    # draw score text
    @window.draw_quad(@p1[0], @p1[1], @color,
                      @p2[0], @p2[1], @color,
                      @p3[0], @p3[1], @color,
                      @p4[0], @p4[1], @color, 1)
  end
end
