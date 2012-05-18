require "fileutils"

desc "Start bot (runs setup if needed)."
task "start" => ["setup"] do
  FileUtils.cd(File.dirname(__FILE__)) do
    system "bundle exec foreman start"
  end
end

desc "Run all setup tasks."
task "setup" => ["setup:dependencies", "setup:configuration", "setup:database"]

desc "Install dependencies."
task "setup:dependencies" do
  FileUtils.cd(File.dirname(__FILE__)) do
    system("gem install bundler")
    system("bundle install")
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
task "setup:database" => ["setup:dependencies", "setup:configuration"] do
  require "sqlite3"
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
  db.execute("
    CREATE TABLE IF NOT EXISTS activities (
      description TEXT NOT NULL,
      channel     TEXT NOT NULL,
      started_at  TEXT NOT NULL,
      ended_at    TEXT NOT NULL
    )"
  )
end
