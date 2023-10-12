# frozen_string_literal: true

CONVERT_PERMISSION_VIEW = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.transform_values(&:freeze).freeze

FILE_TYPE = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l'
}.transform_values(&:freeze).freeze

class FileDetail
  def initialize(contents)
    @stat_files = contents.map { |content| File.lstat(content) }
  end

  def get_detail(contents)
    total_block_size
    necessary_elements = [
      types_and_permissions,
      hard_link,
      owner,
      group,
      file_size,
      last_update_time,
      filename(contents)
    ]
    replaced_elements = necessary_elements.transpose
    replaced_elements.map { |element| element.join(' ') }
  end

  private

  def total_block_size
    bs = 0
    @stat_files.each { |file| bs += file.blocks }
    puts "total #{bs}"
  end

  def file_types
    @stat_files.map { |file| FILE_TYPE[file.ftype] }
  end

  def permissions
    @stat_files.map do |file|
      formatted_permissions = file.mode.to_s(8).slice(-3..-1).split('')
      formatted_permissions.map { |converted_element| CONVERT_PERMISSION_VIEW[converted_element] }.join('')
    end
  end

  def types_and_permissions
    file_types.zip(permissions).map { |file| file.join('') }
  end

  def hard_link
    maximum_digit = @stat_files.map { |element| element.nlink.to_s.length }.max
    @stat_files.map { |element| element.nlink.to_s.rjust(maximum_digit + 1) }
  end

  def owner
    maximum_digit = @stat_files.map { |file| Etc.getpwuid(file.uid).name.length }.max
    @stat_files.map { |file| Etc.getpwuid(file.uid).name.ljust(maximum_digit + 1) }
  end

  def group
    maximum_digit = @stat_files.map { |file| Etc.getgrgid(file.gid).name.length }.max
    @stat_files.map { |file| Etc.getgrgid(file.gid).name.ljust(maximum_digit + 1) }
  end

  def file_size
    maximum_digit = @stat_files.map { |file| file.size.to_s.length }.max
    @stat_files.map { |file| file.size.to_s.rjust(maximum_digit) }
  end

  def last_update_time
    @stat_files.map { |file| file.mtime.strftime('%_m %_d %R') }
  end

  def filename(contents)
    contents.map { |content| FileTest.symlink?(content) ? content + " -> #{File.readlink(content)}" : content }
  end
end
