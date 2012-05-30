require "fileutils"
require "rspec/core/rake_task"

desc "Start bot (runs setup if needed)."
task "start" => ["setup"] do
  FileUtils.cd(File.dirname(__FILE__)) do
    system "bundle exec foreman start"
  end
end

desc "Run all setup tasks."
task "setup" => ["setup:dependencies", "setup:configuration"]

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

desc "Run lib/ tests."
RSpec::Core::RakeTask.new("spec:lib") do |t|
  t.pattern = "spec/lib/**/*_spec.rb"
end

desc "Run app/ tests."
RSpec::Core::RakeTask.new("spec:app") do |t|
  t.pattern = "spec/app/**/*_spec.rb"
end

desc "Run all tests."
task :spec => ["spec:lib", "spec:app"]

task :default => :spec
