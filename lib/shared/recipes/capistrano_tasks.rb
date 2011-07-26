set :scm, :git
set :git_shallow_clone, 1
set :deploy_to, "/home/aleak/a/#{APPDIR}"
set :repository,  "https://github.com/andyl/#{APPDIR}.git"

def get_host
  capture("echo $CAPISTRANO:HOSTS$").strip
end

default_run_options[:pty] = true
set :use_sudo, true

role :primary, PRIMARY if defined?(PRIMARY)
role :backup,  BACKUP  if defined?(BACKUP)

desc "Deploy #{application}"
deploy.task :restart do
  run "touch #{current_path}/tmp/restart.txt"
end

desc "Update gem installation."
task :update_gems do
  system "bundle pack"
  system "cd vendor ; rsync -a --delete cache #{get_host}:a/#{APPDIR}/shared"
  run "cd #{current_path} ; bundle install --quiet --local --path=/home/aleak/.gems"
end

desc "RUN THIS FIRST!"
task :first_deploy do
  check_for_passenger
  run "gem install rspec"
  deploy.setup
  system "/home/aleak/util/bin/vhost add #{get_host}"
  puts "READY TO RUN on #{get_host}"
end

after "deploy:setup", :permissions, :keysend, :deploy, :nginx_conf
after :deploy, :setup_shared_cache, :update_gems, :reload_database, :restart_faye
after :nginx_conf, :restart_nginx

desc "Reload database."
task :reload_database do
  run "cd #{current_path} && bundle exec rake data:import"
end

desc "Restart Faye"
task :restart_faye do
  cmd = "bundle exec foreman export upstart /etc/init -u aleak -a bnet"
  run  "cd #{current_path} && #{sudo} #{cmd}"
  sudo "stop bnet"
  sudo "start bnet"
end

desc "Setup shared cache."
task :setup_shared_cache do
  cache_dir = "#{shared_path}/cache"
  vendor_dir = "#{release_path}/vendor"
  run "mkdir -p #{cache_dir} #{vendor_dir}"
  run "ln -s #{cache_dir} #{vendor_dir}/cache"
end

desc "Send SSH keys to alt55.com."
task :keysend do
   puts "No key setup needed - deploying from GitHub"
end

desc "Set permissions."
task :permissions do
  sudo "chown -R aleak a"
  sudo "chgrp -R aleak a"
end

desc "Create an nginx config file."
task :nginx_conf do
  run "cd #{current_path} && bundle exec rake nginx_conf"
end

desc "Link the database."
task :link_db do
  db_path = "#{shared_path}/db"
  db_file = "#{release_path}/db/development.sqlite3"
  run "rm -f #{db_file}"
  run "ln -s #{db_path}/development.sqlite3 #{db_file}"
  run "touch #{release_path}/tmp/restart.txt"
end

desc "Setup the database."
task :setup_db do
  db_path = "#{shared_path}/db"
  db_file = "#{current_path}/db/development.sqlite3"
  run "rm -f #{db_file}"
  run "cd #{current_path} ; bundle exec rake db:migrate --trace"
  run "cd #{current_path} ; bundle exec rake db:seed --trace"
  run "mkdir -p #{db_path}"
  run "mv #{db_file} #{db_path}"
end

desc "Restart NGINX."
task :restart_nginx do
  sudo "/etc/init.d/nginx restart"
end

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

task :check_for_passenger do
  error_msg = <<-EOF

    ABORT: PLEASE INSTALL PASSENGER, THEN TRY AGAIN !!!
    sys sw install:passenger host=#{get_host}

  EOF
  abort error_msg unless remote_file_exists?("/etc/init.d/nginx")
end

