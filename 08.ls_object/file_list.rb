# frozen_string_literal: true

require_relative 'file_detail'

DISPLAY_NUMBER = 3

class FileList
  def initialize(options)
    dir_contents = Dir.glob('*', options['a'] ? File::FNM_DOTMATCH : 0)
    @dir_contents = options['r'] ? dir_contents.reverse : dir_contents
    @options = options
  end

  def output
    if @options['l']
      stat_files = FileDetail.new(@dir_contents)
      puts stat_files.get_detail(@dir_contents)
    else
      puts display_column_format
    end
  end

  private

  def display_column_format
    height = @dir_contents.size / DISPLAY_NUMBER + 1
    max_length = @dir_contents.map(&:length).max

    aligned_contens = @dir_contents.map { |content| content.ljust(max_length) }.each_slice(height)
    aligned_contens.map { |content| content.values_at(0..height) }.transpose.map { |display| display.join('  ') }
  end
end
