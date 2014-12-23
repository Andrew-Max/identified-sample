# require 'csv'
# # takes csv with format: id,size,color,status,style_id

# namespace :csv do
#   desc "Import CSV Data"
#   task :import => :environment do

#     csv_file_path = "#{Rails.root}/example_csv.csv"

#     CSV.foreach(csv_file_path) do |row|
#       Item.create!({
#         id: row[0],
#         size: row[1],
#         color: row[2],
#         status: row[3],
#         style_id: row[4],
#       })
#       puts "Row added!"
#     end
#   end
# end
