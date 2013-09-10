desc "This task is called by the Heroku scheduler add-on"
task :batch_update_shows => :environment do
  puts "Updating active shows..."
  Show.batch_update_next_airdate!
  puts "Done!"
end