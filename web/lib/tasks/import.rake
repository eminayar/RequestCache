require 'csv'

namespace :import do
  desc "TODO"
  task videos: :environment do
    location = File.join( Rails.root , "data.csv")
    counter = 0
    CSV.foreach( location , :headers => true ) do |row|
      #puts row.to_hash
      Video.create(row.to_hash)
      counter +=1
      puts counter
    end
  end

end
