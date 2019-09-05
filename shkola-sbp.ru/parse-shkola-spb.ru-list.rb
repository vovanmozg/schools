# Скачивает все школы по районам и сохраняет название, id и район в CSV-файл
require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require 'csv'

OUTPUT_FILE = "../data/shkola-sbp.ru/schools-parsed-schkola.sbp.ru.csv"


def process_url(area)
  url = "https://shkola-spb.ru/rajon/#{area}/"
  fh = open(url)
  html = fh.read

  items = []

  html_doc = Nokogiri::HTML(html)
  html_doc.css('#list_content > div').each do |div|
    item = {}
    header = div.css('h2.topborder')
    if header.count == 1
      a = header.css('a')
      item[:name] = (a.text.strip + ' ' + header.css('span').text.strip).strip
      item[:href] = a.attr('href')
      item[:specialisation]
      item[:id] = div.attr('id')
      item[:folk_rating]
      item[:oge]
      item[:ege]
      item[:city_olymp]
      item[:area] = area
      items << item
    else
    end
  end

  items
end


all_keys = [:name, :href, :id, :area]

areas = %w(admiraltejskij vasileostrovskij vyiborgskij kalininskij kirovskij kolpinskij krasnogvardejskij krasnoselskij kronshtadtskij kurortnyij moskovskij nevskij petrogradskij petrodvortsovyij primorskij pushkinskij frunzenskij tsentralnyij)


items = areas.map { |area| process_url(area) }.flatten

CSV.open(OUTPUT_FILE, 'wb') do |file|
  file << all_keys
  items.each do |item|
    file <<  all_keys.map{ |key| item[key] }
  end
end


