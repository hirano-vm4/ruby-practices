#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

DISPLAY_NUMBER = 3

CONVERT_PERMISSION_VIEW = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

FILE_TYPE = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l'
}.freeze

OPTIONS = ARGV.getopts('l')

def main
  if OPTIONS['l']
    total_block_size
    necessary_elements = [
      file_types_and_permissions,
      hard_link,
      user_name,
      group_name,
      data_size,
      last_update_time,
      symlink_filename
    ]
    replaced_elements = necessary_elements.transpose
    replaced_elements.each { |element| puts element.join('  ') }
  else
    puts modified_element(current_elements)
  end
end

def current_elements
  Dir.glob('*')
end

def modified_element(elements)
  height = elements.size / DISPLAY_NUMBER + 1
  string_count = elements.map(&:length).max
  sliced = elements.map { |d| d.ljust(string_count) }.each_slice(height).to_a
  sliced.map { |data| data.values_at(0...height) }.transpose.map { |display| display.join(' ') }
end

# これ以降はlオプションの処理のためのメソッド

def converted_to_statfiles
  current_elements.map { |element| File.lstat(element) }
end

def total_block_size
  bs = 0
  converted_to_statfiles.each do |element|
    bs += element.blocks
  end
  puts "total #{bs}"
end

def file_types
  converted_to_statfiles.map { |element| FILE_TYPE[element.ftype] }
end

def file_permissions
  converted_to_statfiles.map do |element|
    converted_permissions = element.mode.to_s(8).slice(-3..-1).split('')
    converted_permissions.map { |converted_element| CONVERT_PERMISSION_VIEW[converted_element] }.join('')
  end
end

def file_types_and_permissions
  file_types.zip(file_permissions).map { |element| element.join('') }
end

def hard_link
  maximum_digit = converted_to_statfiles.map { |element| element.nlink.to_s.length }.max
  converted_to_statfiles.map { |element| element.nlink.to_s.rjust(maximum_digit) }
end

def user_name
  maximum_digit = converted_to_statfiles.map { |element| Etc.getpwuid(element.uid).name.length }.max
  converted_to_statfiles.map do |element|
    Etc.getpwuid(element.uid).name.ljust(maximum_digit)
  end
end

def group_name
  maximum_digit = converted_to_statfiles.map { |element| Etc.getgrgid(element.gid).name.length }.max
  converted_to_statfiles.map do |element|
    Etc.getgrgid(element.gid).name.ljust(maximum_digit)
  end
end

def data_size
  maximum_digit = converted_to_statfiles.map { |element| element.size.to_s.length }.max
  converted_to_statfiles.map { |element| element.size.to_s.rjust(maximum_digit) }
end

def last_update_time
  converted_to_statfiles.map do |element|
    element.mtime.strftime('%_m %_d %R')
  end
end

def symlink_filename
  current_elements.map do |element|
    FileTest.symlink?(element) ? element + " -> #{File.readlink(element)}" : element
  end
end

main
