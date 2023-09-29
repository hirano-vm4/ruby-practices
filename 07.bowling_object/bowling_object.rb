# frozen_string_literal: true

require_relative 'game'

def main
  formated_argument = format_args(ARGV[0])
  puts Game.new(formated_argument).score
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

main
