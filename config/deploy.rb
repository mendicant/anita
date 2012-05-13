require 'bundler/capistrano'

set :application, "anita"
set :repository,  "git://github.com/mendicant/anita.git"

set :scm, :git
set :deploy_to, "/var/rapp/#{application}"

set :user, "git"
set :use_sudo, false

set :deploy_via, :remote_cache

set :branch, "master"
server "community.mendicantuniversity.org", :app, :web, :db, :primary => true

before 'deploy:update_code' do
  run "sudo god stop anita"
end

after 'deploy:update_code' do
  run "ln -nfs #{shared_path}/environment.rb #{release_path}/config/environment.rb"
  run "ln -nfs #{shared_path}/data #{release_path}/data"
end

after 'deploy' do
  run "sudo god load #{release_path}/config/anita.god"
  run "sudo god start anita"
end

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy", 'deploy:cleanup'