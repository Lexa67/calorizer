# lib/tasks/import_products.rake

namespace :data_import do
    desc "Import products from parsed_data.txt"
    task from_file: :environment do
      file_path = 'parsed_data.txt'
  
      unless File.exist?(file_path)
        puts "File not found: #{file_path}"
        exit
      end
  
      File.open(file_path, "r") do |file|
        product_data = {}
        
        file.each_line do |line|
          if line.start_with?("Product:")
            if product_data.any?
              create_product(product_data)
              product_data.clear
            end
            product_info = line.split("Product: ").last.strip
            # Using regex to split product_info into name and type
            match = product_info.match(/^(.*?)(?:\t+(.+))?$/)
            if match
              product_data[:name] = match[1].strip
              product_data[:product_type] = match[2] ? match[2].strip : nil
            end
          elsif line.start_with?("Calories:")
            product_data[:calories] = line.split("Calories: ").last.strip.split.first.to_f
          elsif line.start_with?("Proteins:")
            product_data[:protein] = line.split("Proteins: ").last.strip.split.first.gsub(",", ".").to_f
          elsif line.start_with?("Fats:")
            product_data[:fat] = line.split("Fats: ").last.strip.split.first.gsub(",", ".").to_f
          elsif line.start_with?("Carbohydrates:")
            product_data[:carbohydrates] = line.split("Carbohydrates: ").last.strip.split.first.gsub(",", ".").to_f
          end
        end
  
        # Create the last product if any data remains
        create_product(product_data) if product_data.any?
      end
  
      puts "Import completed successfully."
    end
  
    def create_product(data)
      Product.create!(
        name: data[:name],
        product_type: data[:product_type],
        protein: data[:protein],
        fat: data[:fat],
        carbohydrates: data[:carbohydrates],
        calories: data[:calories]
      )
      puts "Created product: #{data[:name]}"
    end
  end
  