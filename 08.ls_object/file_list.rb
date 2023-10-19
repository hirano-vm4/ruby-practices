# frozen_string_literal: true

require_relative 'file_detail'

class Directory
  DISPLAY_NUMBER = 3

  def initialize(sorted_contents, options)
    @dir_contents = sorted_contents
    @stat_files = sorted_contents.map { |content| FileDetail.new(content) }
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
    total_block_size
    [
      types_and_permissions,
      hard_links,
      owners,
      groups,
      file_sizes,
      last_modification_time,
      display_names
    ].transpose.map { |element| element.join(' ') }
  end

  def total_block_size
    bs = @stat_files.sum(&:block_size)
    puts "total #{bs}"
  end

  def types_and_permissions
    file_types.zip(permissions).map(&:join)
  end

  def file_types
    @stat_files.map(&:file_type)
  end

  def permissions
    @stat_files.map(&:permission)
  end

  def hard_links
    max_length = @stat_files.map { |element| element.hard_link.length }.max
    @stat_files.map { |element| element.hard_link.rjust(max_length + 1) }
  end

  def owners
    max_length = @stat_files.map { |file| file.owner.length }.max
    @stat_files.map { |file| file.owner.ljust(max_length + 1) }
  end

  def groups
    max_length = @stat_files.map { |file| file.group.length }.max
    @stat_files.map { |file| file.group.ljust(max_length + 1) }
  end

  def file_sizes
    max_length = @stat_files.map { |file| file.file_size.length }.max
    @stat_files.map { |file| file.file_size.rjust(max_length) }
  end

  def last_modification_time
    @stat_files.map(&:last_update_time)
  end

  def display_names
    @stat_files.map(&:file_name)
  end
end
