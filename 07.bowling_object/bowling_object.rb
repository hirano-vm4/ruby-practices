# frozen_string_literal: true

require_relative 'game'

def main
  puts Game.new(ARGV[0]).score
end

main
