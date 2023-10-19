# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_list'

options = ARGV.getopts('arl')
dir_contents = Dir.glob('*', options['a'] ? File::FNM_DOTMATCH : 0)
sorted_contents = options['r'] ? dir_contents.reverse : dir_contents

current_directory = Directory.new(sorted_contents, options)
current_directory.output
