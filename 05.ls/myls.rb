#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

DISPLAY_NUMBER = 3

def main
  puts modified_element(current_element)
end

def current_element
  options = ARGV.getopts('a')
  options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
end

def modified_element(elements)
  height = elements.size / DISPLAY_NUMBER + 1
  string_count = elements.map(&:length).max
  sliced = elements.map { |d| d.ljust(string_count) }.each_slice(height).to_a
  sliced.map { |data| data.values_at(0...height) }.transpose.map { |display| display.join(' ') }
end

main
