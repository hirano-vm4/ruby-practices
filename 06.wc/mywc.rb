#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = option_judgment
  formatted_element = read_file_contents
  formatted_element.each do |filename, content|
    print row_count(content).to_s.rjust(8) if option['l']
    print word_count(content).to_s.rjust(8) if option['w']
    print byte_count(content).to_s.rjust(8) if option['c']
    print " #{filename}\n"
  end
  total_display(formatted_element, option) if formatted_element.size > 1
end

def option_judgment
  option_status = ARGV.getopts('lwc')
  no_option = {
    'l' => true,
    'w' => true,
    'c' => true
  }
  option_status.value?(true) ? option_status : no_option
end

def read_file_contents
  if ARGV.empty?
    contents =
      $stdin.read
    Hash['', contents]
  else
    contents =
      ARGV.map { |file| File.open(file).read }
    Hash[ARGV.zip(contents)]
  end
end

def total_display(elements, option)
  row_sum = 0
  word_sum = 0
  byte_sum = 0
  elements.each_value do |content|
    row_sum += row_count(content)
    word_sum += word_count(content)
    byte_sum += byte_count(content)
  end
  print row_sum.to_s.rjust(8) if option['l']
  print word_sum.to_s.rjust(8) if option['w']
  print byte_sum.to_s.rjust(8) if option['c']
  print ' total'
end

def row_count(element)
  element.split("\n").size
end

def word_count(element)
  element.split("\s").size
end

def byte_count(element)
  element.bytesize
end

main
