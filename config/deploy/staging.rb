require "delayed/recipes"

set :rvm_ruby_string, '1.9.2'
set :rvm_type, :system

set :deploy_to, "/var/www/lifon/data/www/test.life4n.com/#{application}"
set :rails_env, "staging"
set :branch, "mmk"

set :unicorn_conf, "#{deploy_to}/current/config/unicorn/#{rails_env}.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :srv, "82.146.35.96"
role :app, "#{srv}"
role :web, "#{srv}"
role :db, "#{srv}", :primary=> true

after "deploy:setup" do
  run "mkdir -p #{deploy_to}/shared/pids && mkdir -p #{deploy_to}/shared/config && mkdir -p #{deploy_to}/shared/var"
end

after "deploy:restart", "delayed_job:restart"
after "deploy:reload", "delayed_job:restart"

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

# ==============================
# Uploads
# ==============================

namespace :uploads do

  desc <<-EOD
    Creates the upload folders unless they exist
    and sets the proper upload permissions.
  EOD
  task :setup, :except => { :no_release => true } do
    dirs = uploads_dirs.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
  end

  desc <<-EOD
    [internal] Creates the symlink to uploads shared folder
    for the most recently deployed version.
  EOD
  task :symlink, :except => { :no_release => true } do
    run "rm -rf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/#{stage}/uploads #{release_path}/public/uploads"
  end

  desc <<-EOD
    [internal] Computes uploads directory paths
    and registers them in Capistrano environment.

    Note. I can't set value for directories directly in the code because
    I don't know in advance selected stage.
  EOD
  task :register_dirs do
    set :uploads_dirs,    %w(uploads).map { |d| "#{stage}/#{d}" }
    set :shared_children, fetch(:shared_children) + fetch(:uploads_dirs)
  end

  after       "deploy:finalize_update", "uploads:symlink"
  on :start,  "uploads:register_dirs",  :except => stages + ['multistage:prepare']

end


