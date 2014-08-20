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
    color == "O" ? @color = Gosu::Color.argb(0xBBff5b00) : @color = Gosu::Color.argb(0xBB002bff)
    @time = Gosu::milliseconds
  end

  def update
    if Gosu::milliseconds - @time > 1000
      # reduce alpha channel to 00
    end
  end

  def draw
    # binding.pry
    @window.draw_quad(@p1[0], @p1[1], @color,
                      @p2[0], @p2[1], @color,
                      @p3[0], @p3[1], @color,
                      @p4[0], @p4[1], @color, 5)
  end
end
