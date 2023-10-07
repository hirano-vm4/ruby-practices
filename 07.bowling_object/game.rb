# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(bowling_score)
    @frames = format_args(bowling_score).map { |frame| Frame.new(frame[0], frame[1], frame[2]) }
  end

  def score
    @frames.each_with_index.sum do |frame, index|
      next_frame = @frames[index + 1]
      after_next_frame = @frames[index + 2]

      frame.calculate_score(next_frame, after_next_frame, index)
    end
  end

  def format_args(argument)
    game_results = []
    frame = []

    argument.split(',').each do |score|
      if game_results.length < 9
        if score == 'X'
          frame.push(score, 0)
        else
          frame.push(score)
        end

        if frame.length == 2
          game_results.push(frame)
          frame = []
        end
      else
        frame.push(score)
      end
    end
    game_results << frame
  end
end
