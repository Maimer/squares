def check_squares(board)
  color = board.last[0]
  tiles = board.reject { |tile| !tile.start_with?(color) }
  tiles.map! { |tile| [tile[1..-1].to_i % 8 + 1, tile[1..-1].to_i / 8 + 1] }
  last = tiles.pop
  score = 0

  tiles.each do |tile|
    diff_x = tile[0] - last[0]
    diff_y = tile[1] - last[1]
    if tiles.include?([tile[0] - diff_y, tile[1] + diff_x]) &&
       tiles.include?([last[0] - diff_y, last[1] + diff_x])
       d1 = ((last[0]) - (tile[0] - diff_y)).abs + 1
       d2 = ((last[1]) - (tile[1] + diff_x)).abs + 1
       d1 > d2 ? square_size = d1 : square_size = d2
       score += (square_size) ** 2
    end
  end
  score
end
