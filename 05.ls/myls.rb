#!/usr/bin/env ruby
# frozen_string_literal: true

DISPLAY_NUMBER = 3

def current_element
  Dir.glob('*').sort
end

def height
  (current_element.size / DISPLAY_NUMBER) + 1
end

def string_count
  current_element.map(&:length).max
end

def modified_element
  sliced = current_element.map { |d| d.ljust(string_count) }.each_slice(height).to_a
  sliced.map { |data| data.values_at(0...height) }.transpose.map { |display| display.join(' ') }
end

puts modified_element
