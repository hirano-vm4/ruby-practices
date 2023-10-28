# frozen_string_literal: true

class FileDetail
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

  def initialize(content)
    @name = content
    @stat = File.lstat(content)
  end

  def file_type
    FILE_TYPE[@stat.ftype]
  end

  def permission
    octal_mode = @stat.mode.to_s(8).slice(-3..-1).split('')
    octal_mode.map { |octal| CONVERT_PERMISSION_VIEW[octal] }.join('')
  end

  def block_size
    @stat.blocks
  end

  def hard_link
    @stat.nlink.to_s
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def file_size
    @stat.size.to_s
  end

  def last_update_time
    @stat.mtime.strftime('%_m %_d %R')
  end

  def file_name
    File.symlink?(@name) ? @name + " -> #{File.readlink(@name)}" : @name
  end
end
