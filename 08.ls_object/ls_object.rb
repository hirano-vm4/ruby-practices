# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'directory'

options = ARGV.getopts('arl')
current_directory = Directory.new(options)
current_directory.output
