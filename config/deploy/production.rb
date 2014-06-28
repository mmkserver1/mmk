require "whenever/capistrano"

set :application, "health"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

set :deploy_to, "/var/www/lifon/data/www/test.life4n.com/#{application}"
set :rails_env, "production"
set :branch, "master"
set :deploy_via, :remote_cache

set :unicorn_conf, "#{deploy_to}/current/config/unicorn/#{rails_env}.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :srv, "82.146.35.96"
role :app, "#{srv}"
role :web, "#{srv}"
role :db, "#{srv}", :primary=> true

set :whenever_command, "bundle exec whenever"

after 'deploy:update_code', roles: :app do
  run "rm -f #{current_release}/config/backup.rb;"
  run "ln -nfs #{deploy_to}/shared/config/backup.rb #{current_release}/config/backup.rb"

  run "rm -rf #{current_release}/public/uploads"
  run "ln -nfs #{deploy_to}/shared/uploads #{current_release}/public/uploads"
end

namespace :deploy do

  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end

  task :stop do
    run "kill `cat #{unicorn_pid}`; exit 0"
  end

  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end

end


