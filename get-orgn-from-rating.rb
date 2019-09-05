require 'open-uri'
require 'nokogiri'
require 'csv'

URL = 'https://petersburgedu.ru/institution/rating'

rows = []

open(URL) do |file|
  html = file.read
  doc = Nokogiri::HTML(html)
  row = doc.css('table#rating tr')
  row.css('> td a').each do |a|
    ogrn = a.attr('href').gsub(%r(^.*/([^/]+)/$), '\1')
    rows << { name: a.text, ogrn: ogrn}
  end
end

CSV.open('./data/orgn-for-institution-rating-scools.csv', 'wb') do |file|
  file << ['name', 'ogrn']
  rows.each do |row|
    file << row.values
  end
end

