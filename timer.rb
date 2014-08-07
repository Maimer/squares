class Timer
  attr_reader :hours, :minutes, :seconds, :frames

  def initialize
    @hours = 0
    @minutes = 0
    @seconds = 0
    @last_time = 0
  end

  def update
    if (Gosu::milliseconds - @last_time) / 1000 == 1
      @seconds += 1
      @last_time = Gosu::milliseconds()
    end
    if @seconds % 60 == 0
      @seconds = 0
      @minutes += 1
    end
    if @minutes > 59
      @hours += 1
      @minutes = 0
    end
  end
end
