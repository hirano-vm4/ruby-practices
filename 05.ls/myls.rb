#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DISPLAY_NUMBER = 3

def main
  acquired_elements = current_element
  puts modified_element(acquired_elements)
end

def current_element
  options = ARGV.getopts('a')
  options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
end

def modified_element(acquired_elements)
  height = acquired_elements.size / DISPLAY_NUMBER + 1
  string_count = acquired_elements.map(&:length).max
  sliced = acquired_elements.map { |d| d.ljust(string_count) }.each_slice(height).to_a
  sliced.map { |data| data.values_at(0...height) }.transpose.map { |display| display.join(' ') }
end

main
