# frozen_string_literal: true

require_relative 'file_detail'

class Directory
  DISPLAY_NUMBER = 3

  def initialize(options)
    @dir_contents = get_dir_contents(options)
    @options = options
  end

  def output
    if @options['l']
      puts display_content_details
    else
      puts display_contents
    end
  end

  private

  def get_dir_contents(options)
    dir_contents = Dir.glob('*', options['a'] ? File::FNM_DOTMATCH : 0)
    sorted_contents = options['r'] ? dir_contents.reverse : dir_contents
  end

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

  def display_content_details
    stat_files = @dir_contents.map { |content| FileDetail.new(content) }
    total_block_size(stat_files)
    [
      types_and_permissions(stat_files),
      hard_links(stat_files),
      owners(stat_files),
      groups(stat_files),
      file_sizes(stat_files),
      last_modification_time(stat_files),
      display_names(stat_files)
    ].transpose.map { |element| element.join(' ') }
  end

  def total_block_size(stat_files)
    bs = stat_files.sum(&:block_size)
    puts "total #{bs}"
  end

  def types_and_permissions(stat_files)
    stat_files.map(&:file_type).zip(stat_files.map(&:permission)).map(&:join)
  end

  def hard_links(stat_files)
    max_length = stat_files.map { |file| file.hard_link.length }.max
    stat_files.map { |file| file.hard_link.rjust(max_length + 1) }
  end

  def owners(stat_files)
    max_length = stat_files.map { |file| file.owner.length }.max
    stat_files.map { |file| file.owner.ljust(max_length + 1) }
  end

  def groups(stat_files)
    max_length = stat_files.map { |file| file.group.length }.max
    stat_files.map { |file| file.group.ljust(max_length + 1) }
  end

  def file_sizes(stat_files)
    max_length = stat_files.map { |file| file.file_size.length }.max
    stat_files.map { |file| file.file_size.rjust(max_length) }
  end

  def last_modification_time(stat_files)
    stat_files.map(&:last_update_time)
  end

  def display_names(stat_files)
    stat_files.map(&:file_name)
  end
end


