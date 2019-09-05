# берёт  CSV-файлы со школами c https://petersburgedu.ru (школы в файлах сгруппированы по типам)
# и объединяет их в один файл

require 'csv'

files = Dir.glob('./data/data.gov.spb.ru/*.csv')

headers = []
all = []

files.each do |file_name|
  CSV.open(file_name, 'r') do |file|
    headers = file.readline()
    all += file.readlines()
  end
end

all = [headers] + all

CSV.open('data/data.gov.spb.ru.all.txt', 'wb') do |file|
  #file << headers
  all.each { |line| file << line }
end