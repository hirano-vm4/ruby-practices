# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_list'

options = ARGV.getopts('arl')
current_directory = FileList.new(options)
current_directory.output
