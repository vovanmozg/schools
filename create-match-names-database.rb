# создаёт файл в котором название школы может встречаться в разных написаниях.
# файл состоит из двух колонок. В первой колонке название школы, во второй - ОГРН
require 'csv'
require 'awesome_print'

OUTPUT = './data/names.csv'

def start
	items = CSV.read('./data/petersburgedu.ru-full.csv', headers: true)

	CSV.open(OUTPUT, 'wb') do |output|
		output << ['name', 'id']
		items.each do |item|
			["Полное наименование ОУ по Уставу", "Краткое наименование", "Название"].each do |title|				
				output << [item[title], item['ОГРН']]	unless item[title].strip.empty?
			end

			if item['Краткое наименование'].include?('СОШ')
				output << ["Школа № #{item['Номер ОУ']}", item['ОГРН']]
				output << ["Школа №#{item['Номер ОУ']}", item['ОГРН']]
				output << ["№ #{item['Номер ОУ']}, школа", item['ОГРН']]
			end

			if item['Краткое наименование'].include?('гимназия')
				output << ["Гимназия № #{item['Номер ОУ']}", item['ОГРН']]
				output << ["Гимназия №#{item['Номер ОУ']}", item['ОГРН']]
				output << ["№ #{item['Номер ОУ']}, гимназия", item['ОГРН']]
			end
			
			if item['Краткое наименование'].include?('лицей')
				output << ["Лицей № #{item['Номер ОУ']}", item['ОГРН']]
				output << ["Лицей №#{item['Номер ОУ']}", item['ОГРН']]
				output << ["№ #{item['Номер ОУ']}, лицей", item['ОГРН']]
			end
		end
	end
end


start