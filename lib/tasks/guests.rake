namespace :guests do
  desc "Remove guest accounts more than a month old."
  task :cleanup => :environment do
    User.where(guest: :true).where("created_at < ?", 1.month.ago).destroy_all
  end
end