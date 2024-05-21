# lib/parsers/data_parser.rb

require 'httparty'
require 'nokogiri'

class DataParser
  def self.parse
    puts "Starting parser..."

    # URL главной страницы сайта
    url = 'https://fitaudit.ru/food'
    puts "Fetching URL: #{url}"

    # Отправка запроса на главную страницу сайта
    response = HTTParty.get(url)

    # Проверка успешности запроса
    if response.code == 200
      puts "Successfully fetched the main page."

      # Создание объекта Nokogiri из полученного HTML главной страницы
      parsed_page = Nokogiri::HTML(response.body)

      # Пример: извлечение всех элементов, содержащих информацию о продуктах
      product_links = parsed_page.css('.fimlist__item a')

      # Проверка наличия ссылок на продукты
      if product_links.empty?
        puts "No product links found on the main page."
        return
      end

      # Открываем файл для записи
      File.open("parsed_data.txt", "w") do |file|
        # Итерация по каждой ссылке на продукт
        product_links.each do |link|
          product_url = link['href']
          product_name = link.text.strip

          # Записываем название продукта в файл перед переходом на его страницу
          file.puts "Product: #{product_name}"

          # Отправка запроса на страницу продукта
          product_response = HTTParty.get(product_url)

          # Проверка успешности запроса
          if product_response.code == 200
            product_page = Nokogiri::HTML(product_response.body)

            # Извлечение информации о калориях, белках, жирах и углеводах
            calories_element = product_page.at_css('.him_bx__legend_text .js__msr_cc')
            calories = calories_element ? calories_element.text.strip : "N/A"
            proteins_element = product_page.at_css('.him_bx__legend_mark.pr__protein')
            proteins = proteins_element ? proteins_element.next_element.text.strip : "N/A"
            fats_element = product_page.at_css('.him_bx__legend_mark.pr__fat')
            fats = fats_element ? fats_element.next_element.text.strip : "N/A"
            carbohydrates_element = product_page.at_css('.him_bx__legend_mark.pr__carbohydrate')
            carbohydrates = carbohydrates_element ? carbohydrates_element.next_element.text.strip : "N/A"

            # Запись информации в файл
            file.puts "Calories: #{calories}"
            file.puts "Proteins: #{proteins}"
            file.puts "Fats: #{fats}"
            file.puts "Carbohydrates: #{carbohydrates}"
            file.puts "-------------------------------------------"
          else
            puts "Failed to fetch product page: #{product_url}"
          end
        end
      end

      puts "Successfully saved parsing results to parsed_data.txt."
    else
      puts "Ошибка при запросе к сайту: #{response.code}"
    end
  end
end
