def check_squares(board)
  color = board.last[0]
  tiles = board.reject { |tile| !tile.start_with?(color) }
  tiles.map! { |tile| [tile[1..-1].to_i / 8, tile[1..-1].to_i % 8] }
  last_tile = tiles.pop

  puts tiles.inspect
end

b = ["O4", "B7", "O10", "B25", "O60", "B16", "O44", "B22", "O18", "B23"]

check_squares(b)
