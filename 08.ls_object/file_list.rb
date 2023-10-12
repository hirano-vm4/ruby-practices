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
      puts display_contents
    end
  end

  private

  def display_contents
    max_length = @dir_contents.map(&:length).max
    filled_strings = @dir_contents.map { |content| content.ljust(max_length + 3) }
    display_groups = filled_strings.each_slice((@dir_contents.size.to_f / DISPLAY_NUMBER).ceil)
    max_group_size = display_groups.map(&:size).max

    (0..max_group_size).map do |i|
      row = display_groups.map { |group| group[i] }
      row.compact.join('')
    end
  end
end
