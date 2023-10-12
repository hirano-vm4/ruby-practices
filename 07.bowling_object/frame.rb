# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot, third_shot)
    @first_shot = Shot.new(first_shot).to_i
    @second_shot = Shot.new(second_shot).to_i
    @third_shot = Shot.new(third_shot).to_i
  end

  def calculate_score(next_frame, after_next_frame, index)
    frame_score = frame_total
    return frame_score if index == 9

    frame_score += calculate_bonus_score(next_frame, after_next_frame, index)
    frame_score
  end

  def calculate_bonus_score(next_frame, after_next_frame, index)
    if index == 8 && strike?
      next_frame.first_shot + next_frame.second_shot
    elsif strike? && next_frame.strike?
      next_frame.first_shot + after_next_frame.first_shot
    elsif strike?
      next_frame.frame_total
    elsif spare?
      next_frame.first_shot
    else
      0
    end
  end

  def frame_total
    first_shot + second_shot + third_shot
  end

  def strike?
    first_shot == 10
  end

  def spare?
    first_shot != 10 && frame_total == 10
  end
end
