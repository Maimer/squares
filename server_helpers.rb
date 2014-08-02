# require 'pry'

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

# c = ["O0", "B63", "O3", "B47", "O24", "B61", "O54", "B38", "B50", "O30", "B43", "O6", "B7", "O51", "O48"]

# # "O27"

# check_squares(c)
