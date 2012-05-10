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

after 'deploy:update_code' do
  run "ln -nfs #{shared_path}/environment.rb #{release_path}/config/environment.rb"
  run "ln -nfs #{shared_path}/data #{release_path}/data"
end

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy", 'deploy:cleanup'