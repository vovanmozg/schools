# создаёт файл в котором название школы может встречаться в разных написаниях.
# файл состоит из двух колонок. В первой колонке название школы, во второй - ОГРН
require 'csv'
require 'awesome_print'
require_relative('files')

OUTPUT = './data/generated/names.csv'

def start
	items = CSV.read(PETERSBURGEDU, headers: true)
	ids = CSV.read(OGRN_ID_PETERSBURGEDU, headers: true).map { |x| [x[1], x[0]]}.to_h #ap ids

	CSV.open(OUTPUT, 'wb') do |output|
		output << ['name', 'id']
		items.each do |item|
			id = ids[item['ОГРН']]

			["Полное наименование ОУ по Уставу", "Краткое наименование", "Название"].each do |title|				
				output << [item[title], id]	unless item[title].strip.empty?
			end

			if item['Краткое наименование'].include?('СОШ')
				output << ["Школа № #{item['Номер ОУ']}", id]
				output << ["Школа №#{item['Номер ОУ']}", id]
				output << ["№ #{item['Номер ОУ']}, школа", id]
			end

			if item['Краткое наименование'].include?('гимназия')
				output << ["Гимназия № #{item['Номер ОУ']}", id]
				output << ["Гимназия №#{item['Номер ОУ']}", id]
				output << ["№ #{item['Номер ОУ']}, гимназия", id]
			end
			
			if item['Краткое наименование'].include?('лицей')
				output << ["Лицей № #{item['Номер ОУ']}", id]
				output << ["Лицей №#{item['Номер ОУ']}", id]
				output << ["№ #{item['Номер ОУ']}, лицей", id]
			end
		end
	end
end

start