def check_squares(board)
  color = board.last[0]
  tiles = board.reject { |tile| !tile.start_with?(color) }
  tiles.map! { |tile| [tile[1..-1].to_i / 8 + 1, tile[1..-1].to_i % 8 + 1] }
  last = tiles.pop
  score = 0

  puts tiles.inspect
  # puts last.inspect

  tiles.each_with_index do |tile, i|
    diff_x = tile[0] - last[0]
    diff_y = tile[1] - last[1]
    if diff_x < 0 && diff_y <= 0
      if tiles.include?([tile[0] - diff_y, tile[1] + diff_x]) &&
         tiles.include?([last[0] - diff_y, last[1] + diff_x])
         score += ((last[0] - diff_y) - (tile[0] - diff_y) + 1) ** 2
      end
    elsif diff_x >= 0 && diff_y < 0

    elsif diff_x > 0 && diff_y >= 0

    elsif diff_x <= 0 && diff_y > 0

    end
  end
  puts score
end

# b = ["O4", "B7", "O10", "B25", "O60", "B16", "O44", "B22", "O18", "B23"]

c = ["O0", "B63", "O3", "B47", "O24", "B61", "O54", "B38", "O51", "B50", "O30", "B43", "O6", "B7", "O27"]

check_squares(c)
