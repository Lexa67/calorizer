namespace :data_import do
  desc "Импорт данных с сайта"
  task from_web: :environment do
    require_relative '../parsers/data_parser'
    
    DataParser.parse
  end
end
