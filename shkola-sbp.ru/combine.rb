# объединяет списки школ полученные двумя разными скриптами парсинга shkola-spb.ru
# один скрипт парсит списки школ со страниц категорий
# второй скрипт парсит каждую страницу школы
require 'csv'
require 'awesome_print'
require 'set'

list1 = {}
list2 = {}

COMPACT_CSV = '../data/shkola-spb.ru/schools-parsed-schkola.spb.ru.csv'
DETAIL_CSV = '../data/shkola-spb.ru/schools-parsed-detail-schkola.spb.ru.csv'
OUTPUT_FILE = '../data/shkola-spb.ru/schools-schkola.spb.ru.csv'


CSV.open(COMPACT_CSV, 'r') do |file|
  rows = file.readlines

  keys = rows.shift
  rows.each do |row|
    row = keys.zip(row).to_h
    list1[row['name']] = row
  end
end


CSV.open(DETAIL_CSV, 'r') do |file|
  rows = file.readlines

  keys = rows.shift
  rows.each do |row|
    row = keys.zip(row).to_h
    list2[row['title']] = row
  end
end

list3 = {}

all_keys = Set.new
list1.each do |name, list1_item|
  if list2[name]
    list3[name] = list1_item.merge(list2[name])
    all_keys.merge(list3[name].keys)
  end
end

all_keys.delete('title')

CSV.open(OUTPUT_FILE, 'wb') do |file|
  file << all_keys
  list3.values.each do |row|
    file << all_keys.map { |key| row[key] }
  end
end
