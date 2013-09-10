desc "This task is called by the Heroku scheduler add-on"
task :batch_update_shows => :environment do
  puts "Updating active shows..."
  Show.batch_update_next_airdate!
  puts "Done!"
end

desc "Remove guest accounts more than a month old."
task :cleanup => :environment do
  User.where(guest: :true).where("created_at < ?", 1.month.ago).destroy_all
end