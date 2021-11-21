require 'roo'
require 'awesome_print'
require 'nokogiri'
require "damerau-levenshtein"
require 'amatch'
require 'csv'

include Amatch


def get_raw_text(cell)
	Nokogiri::HTML(cell).text
end

def get_words(raw_text)
	raw_text.split(/[^а-яА-ЯёЁ0-9]+/).reject(&:empty?)
end

def get_text(words)
	words.join(' ')
end

# @param cell [ячейка]
# @return [Array<String>] массив, содержащий слова только из букв и цифр, без пустых элементов
# def get_words(cell)
# 	doc = Nokogiri::HTML(cell)
# 	words = doc.text.split(/[^а-яА-ЯёЁ0-9]+/).reject(&:empty?)
# 	text = words.join(' ')
# 	[words, text, doc.text]
# end

def cache_get(key)
  $cache[key]
end

def cache_set(key, value)
  $cache[key] = value
end

def calc_max_weight(raw_text, normalized_strings, row, col)
  max_distance = cache_get(raw_text)
  return max_distance if max_distance

	#normalized_strings = strings.map{ |s| { value: get_text(get_words(get_raw_text(s))), original: s} }
	words = get_words(raw_text)
	text = get_text(words)

	# Какой строке из strings наиболее соответствует значение ячейки?
	max_distance = { value: 0.0, row: 0, col: 0}

	normalized_strings.each_with_index do |object, index|
		string = object[:value]
		m = PairDistance.new(string)
		distance = m.match(text)

		if distance > max_distance[:value]
			max_distance[:value] = distance
			max_distance[:row] = row
			max_distance[:col] = col
			max_distance[:text] = text
			max_distance[:raw_text] = raw_text
			max_distance[:string] = string
			max_distance[:original] = object[:original]
			max_distance[:index] = index
		end
	end

  cache_set(raw_text, max_distance)
	max_distance
end

def process_file(file_name)
	p file_name
	#fname = '/Users/vovanmozg/Yandex.Disk-vovanmozg2.localized/schools3/56/samoobsledovanie2018.pdf.xlsx'
#fname = '/media/sda/yandex_disk/schools/262/262-1.xlsx'

#xls = Spreadsheet.open(fname) and true
	xls = Roo::Spreadsheet.open(file_name)

#p xls.methods.grep(/sheet/)
	sheet = xls.sheet('Sheet1')

#p sheet.methods.grep(/row/)

	i = 0
	r = 0
	c = 0



	weights = {}
	weight_total = Hash.new(0)
	subtable = {}

	potencial_subtable_row_count = 0
	(sheet.first_row..sheet.last_row).each do |row|
		(sheet.first_column..sheet.last_column).each do |col|
			# игнорировать пустые ячейки
			next unless xls.cell(row, col)

			raw_text = get_raw_text(xls.cell(row, col))
			words = get_words(raw_text)

			next if words.empty?

			# найти в $strings наиболее близкое слово и вернуть вес
			max_weight = calc_max_weight(raw_text, $strings, row, col)

			if max_weight[:value] > 0.0
				weights[row] = {} unless weights[row]
				weights[row][col] = max_weight
			end

			weight_total[col] << max_weight[:value]

			if max_weight[:value] > 0.9
				subtable[:first_row] = subtable[:first_row] || row

				subtable[:last_row] = row

				subtable[:first_col] = col if subtable[:first_col].nil?
				unless subtable[:first_col].nil?
					subtable[:first_col] = col if col < subtable[:first_col]
				end

				subtable[:last_col] = col if subtable[:last_col].nil?
				unless subtable[:last_col].nil?
					subtable[:last_col] = col if col > subtable[:last_col]
				end

				weight_total[col] += 1
				print '+'
			else
				print '.'
			end

			# next
			#strings

			# if xls.cell(row,col)
			# 	doc = Nokogiri::HTML(xls.cell(row,col))

			# 	words = doc.text.split(/[^а-яА-ЯёЁ]+/).reject(&:empty?)

			# 	unless words.empty?
			# 		item = {
			# 			#text: doc.text.gsub(/[^а-яА-ЯёЁ]+/, ' ').gsub(/ +/, ' ').strip,
			# 			text: words.join(' '),
			# 			value: xls.cell(row,col),
			# 			row: row,
			# 			col: col
			# 		}
			# 		vars << item
			# 	end
			# end
		end
	end

	puts ''

	# p '-------------------'
	# weight_total_cols = weight_total.keys
	# weight_total_cols.each do |key|
	# 	values = weight_total[key]
	# 	p key
	# 	p values
	#
	# 	weight_total[key] = values.sum / values.size.to_f
	# end

	ap weight_total
	#ap subtable
	#ap weights

	# return weights

	# str = vars.map{|v| v[:text]}.join(' ')
	#
	# #index = str.index('Показатели')
	# indexes = str.enum_for(:scan, /(?=Показатели)/).map { Regexp.last_match.offset(0).first }
	#
	# p '-------------------------------------'
	# indexes.each do |index|
	# 	fact = str[index..index + 100]
	# 	#p fact
	#
	# 	ideal = 'Показатели Единица измерения Образовательная деятельность Общая численность учащихся'
	# 	m = PairDistance.new(ideal)
	#
	# 	distance = m.match(fact)
	# 	#if distance > 0.9
	# 		p distance
	# 	#end
	#
	# end




	# return

	# (sheet.first_row..sheet.last_row).each do |row|
	# 	(sheet.first_column..sheet.last_column).each do |col|
	# 		if xls.cell(row,col)
	#
	# 			doc = Nokogiri::HTML(xls.cell(row,col))
	# 			if doc.text == 'Показатели'
	# 				p '----------------'
	# 				if xls.cell(row, col - 1)
	# 					doc2 = Nokogiri::HTML(xls.cell(row, col - 1))
	# 					p doc2.text
	# 				end
	#
	#
	#
	# 				#p xls.cell(row - 1, col - 1)
	# 				#p xls.cell(row - 1, col)
	# 				r = row
	# 				c  = col
	# 			end
	# 		end
	# 	end
	# end

	# p r, c

	#exit

	#
	#
	# sheet.each_row_streaming do |row|
	# 	p row.public_methods
	# 	exit
	# end

end


# @return [Hash] like { [2029, 2] => 'Содержимое ячейки', ...}
def convert_to_a(xls)
  sheet = xls.sheet('Sheet1')

  res = {}

  (sheet.first_row..sheet.last_row).each do |row|
    (sheet.first_column..sheet.last_column).each do |col|
      # игнорировать пустые ячейки
      next unless xls.cell(row, col)

      res[[row, col]] = get_raw_text(xls.cell(row, col))
    end
  end

  res
end

def find_titles(table)

  titles = {}
  weight_total = Hash.new(0)
  subtable_params = {}

  table.each do |(row, col), text|
    # найти в $strings наиболее близкое слово и вернуть вес
    max_weight = calc_max_weight(text, $normalized_strings, row, col)

    weight_total[col] << max_weight[:value]

    if max_weight[:value] > 0.9
      titles[[row, col]] = max_weight


      subtable_params[:first_row] = subtable_params[:first_row] || row

      subtable_params[:last_row] = row

      subtable_params[:first_col] = col if subtable_params[:first_col].nil?
      unless subtable_params[:first_col].nil?
        subtable_params[:first_col] = col if col < subtable_params[:first_col]
      end

      subtable_params[:last_col] = col if subtable_params[:last_col].nil?
      unless subtable_params[:last_col].nil?
        subtable_params[:last_col] = col if col > subtable_params[:last_col]
      end

      weight_total[col] += 1
      #print '+'
    else
      #print '.'
    end
  end

  {
    titles: titles,
    subtable_params: subtable_params
  }
end

def find_values(table, titles)
  values = {}

  titles.each do |(row, col), item|
    row2 = item[:index] + 1
    #col = item[:col]
    values[[row2, col]] = item[:string]
    values[[row2, col - 1]] = table[[row, col - 1]]
    values[[row2, col + 1]] = table[[row, col + 1]]
  end

  values
end

def format_to_export(values)
  table = []

  values.each do |(row, col), value|
    table[row-1] ||= []
    table[row-1][col-1] = value
  end

  table
end

def export(table, file_name)
  CSV.open("#{file_name}.csv", 'w') do |csv|
    csv << ['n', 'title', 'value']

    table.each do |row|
      csv << row if row
    end
  end
end

def process_file2(file_name)
  xls = Roo::Spreadsheet.open(file_name)
  table = convert_to_a(xls)
  data = find_titles(table)
  values = find_values(table, data[:titles])
  formatted_table = format_to_export(values)
  export(formatted_table, file_name)

end

def main
  $cache = {}

# откючить варнинги парсера XLSX
  Zip.warn_invalid_date = false

  $strings = IO.readlines('./strings.txt').map(&:chomp)
  $normalized_strings = $strings.map{ |s| { value: get_text(get_words(get_raw_text(s))), original: s} }


  files = Dir.glob('/Users/vovanmozg/Yandex.Disk-vovanmozg2.localized/schools3/**/*.xlsx') +
    Dir.glob('/media/sda/yandex_disk/schools3/**/*.xlsx')

# исключить временные файлы (восстановления excel)
  files.reject! { |file_name| File.basename(file_name) =~ /^~/  }

  files.each do |file_name|
    weights = process_file2(file_name)

    exit # process only one file
  end
end

main




###########################################################################################

#sheets = xls.worksheets #('Sheet1')


#sheet.rows.each do |row|
	#p row.to_s.force_encoding("ascii").encode("UTF-8")
#	p row.to_s#.encode("UTF-16") #.encode("windows-1251")
	#p CharDet.detect(row.to_s)
#end

# sheet.each do |hash|
#   puts hash
#   # => { id: 1, name: 'John Smith' }
# end

#IO.write('./tmp/1.txt', out.to_s)


# ods.sheets
# # => ['Info', 'Sheet 2', 'Sheet 3']   # an Array of sheet names in the workbook

# ods.sheet('Info').row(1)
# ods.sheet(0).row(1)

# # Set the last sheet as the default sheet.
# ods.default_sheet = ods.sheets.last
# ods.default_sheet = ods.sheets[2]
# ods.default_sheet = 'Sheet 3'

# # Iterate through each sheet
# ods.each_with_pagename do |name, sheet|
#   p sheet.row(1)
# end