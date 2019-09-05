
require 'csv'

CSV.open('data/data.gov.spb.ru-data-20190621T141553-structure-20161130T141543.csv', 'r') do |file|
  p file.readlines()[4]
end