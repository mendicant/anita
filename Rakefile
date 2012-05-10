require "fileutils"
require "sqlite3"

desc "Start bot (runs setup if needed)."
task "start" => ["setup"] do
  FileUtils.cd(File.dirname(__FILE__)) do
    system "bundle exec ruby bin/anita"
  end
end

desc "Run all setup tasks."
task "setup" => ["setup:configuration", "setup:database"]

desc "Install dependencies."
task "setup:dependencies" do
  FileUtils.cd(File.dirname(__FILE__)) do
    unless File.exists?("Gemfile.lock")
      system("gem install bundler")
      system("bundle install")
    end
  end
end

desc "Create default configuration."
task "setup:configuration" do
  dir = File.expand_path(File.dirname(__FILE__) + "/config")

  unless File.exists?(dir + "/environment.rb")
    FileUtils.cp(
      dir + "/environment.rb.example",
      dir + "/environment.rb"
    )

    system("$EDITOR #{dir}/environment.rb")
  end
end

desc "Initialize database."
task "setup:database" => ["setup:configuration", "setup:dependencies"] do
  require_relative "config/environment"

  dir = File.dirname(Anita::Config::DB)
  FileUtils.mkdir(dir) unless Dir.exists?(dir)

  db = SQLite3::Database.new(Anita::Config::DB)
  db.execute("
    CREATE TABLE IF NOT EXISTS transcripts (
      timestamp TEXT NOT NULL,
      channel   TEXT NOT NULL,
      nick      TEXT NOT NULL,
      text      TEXT NOT NULL
    )"
  )
end
