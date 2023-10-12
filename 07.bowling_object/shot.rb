# frozen_string_literal: true

class Shot
  def initialize(point)
    @point = point
  end

  def to_i
    @point == 'X' ? 10 : @point.to_i
  end
end
