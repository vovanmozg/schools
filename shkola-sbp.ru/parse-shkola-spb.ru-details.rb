# Скачивает все школы по районам и сохраняет название, id и район в CSV-файл
require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require 'csv'
require 'set'
require_relative('../files')

INPUT_FILES_MASK = '../data/downloaded/shkolaspb/cache/*.htm'


schools = []

Dir.glob(INPUT_FILES_MASK).each do |file_name|
  print '.'
  html = IO.read(file_name)
  doc = Nokogiri::HTML(html)

  phones = doc.css('span.tel')
             .map(&:text)
             .map(&:strip)
             .uniq
             .map { |a| a.gsub(/\D/, '') }
             .join("|")


  a_reviews = doc.css('a[href="#comments"]')
  reviews = a_reviews[1] && a_reviews[1]['title'] ? a_reviews[1]['title'].gsub(/\D/,'') : '0'

  schools << {
    title: doc.css('div#company-title h1').text.strip,
    city_olymp: doc.css('div.shild3').text.strip,
    ege: doc.css('div.shild1').text.strip,
    oge: doc.css('div.shild4').text.strip,
    folk_rating: doc.css('div.shild2').text.strip,
    reviews: reviews,
    specialisation: doc.css('div#company a span.category').map(&:text).map(&:strip).uniq.join("|"),
    url_id: file_name.gsub(%r(./data/shkola-sbp.ru/cache/(.*).htm), '\1'),
    phones: phones,
    url: doc.css('a span.url').text.gsub('http://', '').gsub(%r(/$), '')
  }
end


all_keys = [:title, :city_olymp, :ege, :oge, :folk_rating, :reviews, :specialisation, :url_id, :phones, :url]

CSV.open(File.join('..',SHKOLASPB_PARSED_DETAIL), 'wb') do |file|
  file << all_keys
  schools.each do |item|
    file << all_keys.map{ |key| item[key] }
  end
end

