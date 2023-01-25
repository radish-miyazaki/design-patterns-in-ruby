require 'finder'
require 'singleton'

class PackRat
  include Singleton

  def initialize
    @backups = []
  end

  def register_backup(backup)
    @backups << backup
  end

  def run
    threads = []
    @backups.each do |backup|
      threads << Thread.new(backup.run)
    end
    threads.each { |t| t.join }
  end
end

class Backup
  attr_accessor :backup_dir, :interval
  attr_reader :data_sources

  def initialize
    @data_sources = []
    @backup_dir = '/backup'
    @interval = 60
    yield(self) if block_given?
    PackRat.instance.register_backup(self)
  end

  def backup(dir, find_expr = All.new)
    Backup.instance.data_sources << DataSource.new(dir, find_expr)
  end

  def to(backup_dir)
    Backup.instance.backup_dir = backup_dir
  end

  def interval(minutes)
    Backup.instance.interval = minutes
  end

  def backup_files
    this_backup_dir = Time.new.ctime.tr(' :', "_")
    this_backup_path = File.join(backup_dir, this_backup_dir)
    @data_sources.each { |source| source.backup(this_backup_path) }
  end

  def run
    while true
      this_backup_dir = Time.new.ctime.tr(' :', "_")
      this_backup_path = File.join(backup_dir, this_backup_dir)
      @data_sources.each { |source| source.backup(this_backup_path) }
      sleep(@interval*60)
    end
  end
end

class DataSource
  attr_reader :dir, :finder_expr

  def initialize(dir, finder_expr)
    @dir = dir
    @finder_expr = finder_expr
  end

  def backup(backup_dir)
    files = @finder_expr.evaluate(@dir)
    files.each do |file|
      backup_file(file, backup_dir)
    end
  end

  def backup_file(path, backup_dir)
    copy_path = File.join(backup_dir, path)
    FileUtils.mkdir_p(File.dirname(copy_path))
    FileUtils.cp(path, copy_path)
  end
end

eval(File.read('backup.pr'))
PackRat.instance.run