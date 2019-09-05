# берёт два списка с названиями школ и сопоставляет названия из одного списка названиям из другого
# Дело в том, что в разных местах навания школ отличаются деталями (например "ГБОУ СОШ №133" и "Школа 133 Московского района")
require 'csv'
require 'awesome_print'
#require "damerau-levenshtein"

# школы из petersburgedu.ru, которые не попали в итоговый список
NOT_USED = './data/not_used.csv'

# школы из shkola.spb.ru, для которых не удалось найти сопоставления в petersburgedu.ru
NOT_FOUND = './data/not_found.csv'

def start
	names = CSV.read('./data/names.csv', headers: true).map { |a| Hash[a] }
	p_items = CSV.read('./data/petersburgedu.ru-full.csv', headers: true).map { |a| Hash[a] }
	s_items = CSV.read('./data/shkola-spb.ru/schools-schkola.spb.ru.csv', headers: true).map { |a| Hash[a] }
	m_items = CSV.read('./data/shkolaspb-orgn-manual.csv', headers: true).map { |a| Hash[a] }
	output = CSV.open('./data/shkola-spb.ru/schools-schkola.spb.ru-with-id.csv', 'w')
	
	output << s_items[0].keys + ['main_id', 'detector']


	not_found = CSV.open(NOT_FOUND, 'w')
	not_found << s_items[0].keys



	s_items.each do |s_item|
		print '.'
		troubles = []

		################
		found = select_manual(s_item['id'], m_items)
		if found.count == 1
			found_rest, names = names.partition { |a| a['id'] == found[0]['id'] }
			output << s_item.values + [found[0]['ogrn'], 'select_manual']
			next
		elsif found.count > 1
			troubles << [s_item, found, 'select_manual']
		end

		################
		found = select_exactly(s_item['name'], names)
		if found.count == 1
			found_rest, names = names.partition { |a| a['id'] == found[0]['id'] }
			output << s_item.values + [found[0]['id'], 'select_exactly']
			next
		elsif found.count > 1
			troubles << [s_item, found, 'select_exactly']
		end

		################
		found = select_including(s_item['name'], names)
		if found.count == 1
			found_rest, names = names.partition { |a| a['id'] == found[0]['id'] }
			output << s_item.values + [found[0]['id'], 'select_including']
			next
		elsif found.count > 1
			troubles << [s_item, found, 'select_including']
		end

		################
		found = select_by_words(s_item['name'], names)
		if found.count == 1
			found_rest, names = names.partition { |a| a['id'] == found[0]['id'] }
			output << s_item.values + [found[0]['id'], 'select_by_words']
			next
		elsif found.count > 1
			troubles << [s_item, found, 'select_by_words']
		end

		################
		found = select_by_number(s_item['name'], names)
		if found.count == 1
			found_rest, names = names.partition { |a| a['id'] == found[0]['id'] }
			output << s_item.values + [found[0]['id'], 'select_by_number']

			next
		elsif found.count > 1
			if found.map { |a| a['id'] }.uniq.count == 1
				found_rest, names = names.partition { |a| a['id'] == found[0]['id'] }
				output << s_item.values + [found[0]['id'], 'select_by_number']
				next
			else
				troubles << [s_item, found, 'select_by_number']
				#ap found
			end
		end

		################
		found = select_by_phones(s_item['phones'], p_items)
		if found.count == 1
			found_rest, names = names.partition { |a| a['id'] == found[0]['id'] }
			output << s_item.values + [found[0]['ОГРН'], 'select_by_phones']
			next
		end

		################
		found = select_by_url(s_item['url'], p_items)
		if found.count == 1
			found_rest, names = names.partition { |a| a['id'] == found[0]['id'] }
			output << s_item.values + [found[0]['ОГРН'], 'select_by_url']
			next
		elsif found.count > 1
			troubles << [s_item, found, 'select_by_url']
		else

		end

		#ap found



		if troubles.empty?
			#p 'школа не найдена:'
			#ap s_item
			not_found << s_item.values
		else
			p 'найдено несколько школ:'
			ap s_item
			ap troubles
		end

	end

	not_found.close

#	p '-------- не использованные имена'
	CSV.open(NOT_USED, 'w') do |file|
		file << ['name', 'ogrn']
		names.each { |x| file << x.values }
	end

	
	output.close

	#petersburgedu.each do |p_item|
		# shkola_sbp.each do |s_item|
		# 	s_value = s_item['name']
		# 	p_value = p_item['Краткое наименование']
		# 	distance = DamerauLevenshtein.distance(s_value, p_value)
		# 	lines["#{s_value}|#{p_value}"] = distance
		# end


		#p_values = keys_petersburgedu.each { |key| item1[key] }



	#end

	#ap lines.sort_by {|_key, value| value}.first(10)

end


def select_manual(id, m_items)
	m_items.select { |item| item['id'] == id }
end

def select_by_phones(phones, p_items)
	phones = phones.split('|')
	p_items.select do |item|
		phone = item['Телефон'].gsub(/\D/,'').gsub(/^8812/,'812')
		phones.include?(phone)
	end
end

def select_by_url(url, p_items)
	return [] if url.empty?
	p_items.select do |item|
		item_url = item['Адрес сайта'].gsub('http://', '').gsub(%r(/$), '')
		url == item_url || "www.#{url}" == item_url || url == "www.#{item_url}"
	end
end

def select_by_number(name, names)
	matches = /(\d+)/.match(name)
	return [] unless matches

	number = matches[0]
	names.select { |item| /(\D|^)#{number}(\D|$)/.match(item['name'].strip) }
end


def select_by_number_old(name, names)
	matches = /(\d+)/.match(name)

	return [] unless matches

	if matches.captures.count == 1
		number = matches[0]
		found1 = select_by_name(number, names)
		found2 = select_by_short_name(number, names)
		found3 = select_by_full_name(number, names)
		found4 = select_ou_number(number, names)

		p found1.count + found2.count + found3.count + found4.count
		if found.count > 0
			#p '--------'

			#p found[0]['Название']
		else

		end

	else

	end


end

def select_by_name(number, p_list)
	select_by_field(number, p_list, 'Название')
end

def select_by_short_name(number, p_list)
	select_by_field(number, p_list, 'Краткое наименование')
end

def select_by_full_name(number, p_list)
	select_by_field(number, p_list, 'Полное наименование ОУ по Уставу')
end

def select_by_ou_number(number, p_list)
	select_by_field(number, p_list, 'Номер ОУ')
end

def select_by_field(number, names, field)
	ap field
	names.select { |item| item[field].strip.include?(number.to_s) }
end

def select_by_words(name, names)
	return []
	name = name.downcase
	names.select { |item| item['name'].split.sort == name.split.sort }
end

# выбирает точные совпадения по одному из полей
def select_exactly(name, names)
	name = name.downcase
	found = names.select { |item| item['name'].strip.downcase == name }
	#rest = names - found
	#[found, rest]
end

# выбирает названия по вхождения
def select_including(name, names)
	name = name.downcase
	names.select { |item| item['name'].strip.downcase.include?(name) }
end


start
