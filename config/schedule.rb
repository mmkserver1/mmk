application = "mmk"
rails_env = "production"
ruby = "1.9.3"
deploy_to = "/srv/#{application}"
current = "#{deploy_to}/current"
unicorn_conf = "#{current}/config/unicorn/#{rails_env}.rb"
unicorn_pid = "#{deploy_to}/shared/pids/unicorn.pid"

if environment == 'production'
  every 1.minute do
    command "if [ ! -f #{unicorn_pid} ] || [ ! -e /proc/$(cat #{unicorn_pid}) ]; then rvm #{ruby} && cd #{current} && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end

  every :day, :at => '10pm' do
    command "rvm #{ruby} && cd #{current} && bundle exec backup perform --trigger #{application} --config-file #{current}/config/backup.rb"
  end
end

