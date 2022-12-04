#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  option = option_judgment
  file_contents = read_file_contents
  file_contents.each do |filename, content|
    print row_count(content).to_s.rjust(8) if option['l']
    print word_count(content).to_s.rjust(8) if option['w']
    print byte_count(content).to_s.rjust(8) if option['c']
    print " #{filename}\n"
  end
  total_display(file_contents, option) if file_contents.size > 1
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
    { '' => contents }
  else
    contents =
      ARGV.map { |file| File.open(file).read }
    ARGV.zip(contents).to_h
  end
end

def total_display(contents, option)
  row_sum = 0
  word_sum = 0
  byte_sum = 0
  contents.each_value do |content|
    row_sum += row_count(content)
    word_sum += word_count(content)
    byte_sum += byte_count(content)
  end
  print row_sum.to_s.rjust(8) if option['l']
  print word_sum.to_s.rjust(8) if option['w']
  print byte_sum.to_s.rjust(8) if option['c']
  print ' total'
end

def row_count(content)
  content.split("\n").size
end

def word_count(content)
  content.split("\s").size
end

def byte_count(content)
  content.bytesize
end

main
