#!/usr/bin/env ruby
require 'yaml'

CONFIG_FILE = File.expand_path("~/.bak.yml")

defaults = {}
defaults["trash"] = "~/.Trash"
defaults["default"] = "w"
defaults["dirs"] = { "w" => "~/bak/work", "p" => "~/Dropbox/Archive" }

opts = YAML::load(File.read(CONFIG_FILE)) || {}
defaults.merge!(opts)

dirs = defaults["dirs"]
trash_dir = defaults["trash"]
archive_dir = dirs[defaults["default"]]

def wrap_text(txt, col = 80)
  txt.gsub(/(.{1,#{col}})( +|$\n?)|(.{1,#{col}})/, "\\1\\3\n")
end

def usage archive_dir, trash_dir, dirs, error=nil
  STDERR.puts error if error
  long_description = <<-eos
backs up the specified files to #{archive_dir} (default) or one of the
following dirs listed at the end of this message. Also, if a directory
is given, it zips the directory and moves the original directory to the
system trash (#{trash_dir}). Directories are configured in #{CONFIG_FILE}.
eos
  wrapped_description = wrap_text(long_description.split("\n").join(" "), 78)
  puts <<-eos
usage: bak [#{dirs.keys.map {|k| "-#{k}"}.join("|")}] [-v] [file_or_dir]...
  #{wrapped_description.split("\n").join("\n  ")}

  Example: bak foo.txt => #{archive_dir}/2007-10-26 foo.txt

  Dirs
  ------
#{dirs.map { |k,d| "    #{k}:\t#{d}" }.join("\n") }
eos
  exit 1
end

usage(archive_dir, trash_dir, dirs) if ARGV.size == 0

files = []
ARGV.each do |arg|
  if arg == "-v"
    verbose = true
  else
    dir_key = arg.gsub(/^-/,'')

    if dirs.keys.include?(dir_key)
      config_dir_name = dirs[arg.gsub(/^-/,'')]
      archive_dir = File.expand_path(config_dir_name)
      if !File.exists?(archive_dir)
        STDERR.puts "Cannot find dir '#{dir_key}': #{config_dir_name} (#{archive_dir})."
        exit 1
      end
    else
      files << arg
    end
  end
end

if files.size == 0
  usage(archive_dir, trash_dir, dirs, "No files given.")
end

files.each do |file|
  date = File::Stat.new(file).mtime.strftime("%F")
  if File.directory?(file)
    file = file.chop if file[-1] == '/'
    `zip -ro "#{file}.zip" "#{file}"`

    # Trash the file
    name = File.basename(file)
    if File.exists?(File.join(trash_dir, name))
      base = File.basename(file, ".*")
      name = "#{base} #{date} #{"%04d" % rand(10_000)}"
    end
    STDERR.puts "Moving '#{file}' to '#{File.join(trash_dir, name)}'"
    `mv "#{file}" "#{File.join(trash_dir, name)}"`

    file = "#{name}.zip"
  end
  STDERR.puts "Archived #{file} to #{File.join(archive_dir, "#{date} #{file}")}"
  `mv "#{file}" "#{File.join(archive_dir, "#{date} #{file}")}"`
end