# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(frames)
    @frames = frames.map { |frame| Frame.new(frame[0], frame[1], frame[2]) }
  end

  def score
    @frames.each_with_index.sum do |frame, index|
      next_frame = @frames[index + 1]
      after_next_frame = @frames[index + 2]

      frame.calculate_score(next_frame, after_next_frame, index)
    end
  end
end
