$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'capistrano'
require 'bundler/capistrano'

set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "health"

set :scm, :git
set :scm_passphrase, "EgiTodi1"
set :repository,  "git@github.com:mmkserver1/mmk.git"
set :deploy_via, :copy
set :copy_strategy, :export

set :user, 'lifon'
set :use_sudo, false
