namespace :db do

  desc "Symlink the production database"
  task :production_symlink do
    production_db = "db/production.sqlite3"
    shared_dir    = "/home/aleak/a/BAMRU-Private/shared/db"
    shared_db     = shared_dir + '/production.sqlite3'
    abort("Exit: No production database") unless File.exist?(production_db)
    abort("Exit: No symlink directory") unless File.exist?(shared_dir)
    system "mkdir -p #{shared_dir}"
    system "mv #{production_db} #{shared_db}"
    system "ln -s #{shared_db} #{production_db}"
    puts "OK"
  end

end
