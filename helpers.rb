module Drawing
  def self.draw_text(x, y, text, font, color)
    font.draw(text, x, y, 20, 1, 1, color)
  end

  def self.draw_rect(window, x, y, width, height, color)
    window.draw_quad(x, y, color, x + width, y, color, x + width,
              y + height, color, x, y + height, color, 10)
  end

  def self.text_center(window, text, font)
    (window.width - font.text_width(text)) / 2
  end
end
