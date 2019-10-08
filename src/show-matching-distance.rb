# Показывает для каждого найденного XLSX вывод в таком формате
# "/Users/vovanmozg/Yandex.Disk-vovanmozg2.localized/schools3/232/samoobsledovanie2018.pdf.xlsx"
# "-------------------------------------"
# 0.6950819672131148
# 0.5930599369085173
# 0.6158730158730159
# 0.6560509554140127
# 0.9358974358974359
# 0.5889967637540453
# Здесь значит, что в документе слово "Показатели" найдено 6 раз. Одно из значений очень близко к единице
# (0.9358974358974359) это значит, что в этом месте документа содержится нужная нам таблица
require 'roo'
require 'awesome_print'
require 'nokogiri'
require 'amatch'
include Amatch

Zip.warn_invalid_date = false

def process_file(file_name)
  p file_name

  xls = Roo::Spreadsheet.open(file_name)

  sheet = xls.sheet('Sheet1')

  vars = []

  (sheet.first_row..sheet.last_row).each do |row|
    (sheet.first_column..sheet.last_column).each do |col|
      if xls.cell(row, col)
        doc = Nokogiri::HTML(xls.cell(row, col))

        words = doc.text.split(/[^а-яА-ЯёЁ]+/).reject(&:empty?)

        unless words.empty?
          item = {
            #text: doc.text.gsub(/[^а-яА-ЯёЁ]+/, ' ').gsub(/ +/, ' ').strip,
            text: words.join(' '),
            value: xls.cell(row, col),
            row: row,
            col: col
          }
          vars << item
        end
      end
    end
  end

  str = vars.map { |v| v[:text] }.join(' ')

  indexes = str.enum_for(:scan, /(?=Показатели)/).map { Regexp.last_match.offset(0).first }

  p '-------------------------------------'
  indexes.each do |index|
    fact = str[index..index + 100]
    #p fact

    ideal = 'Показатели Единица измерения Образовательная деятельность Общая численность учащихся'
    m = PairDistance.new(ideal)

    distance = m.match(fact)
    #if distance > 0.9
    p distance
    #end

  end


end


files = Dir.glob('/Users/vovanmozg/Yandex.Disk-vovanmozg2.localized/schools3/**/*.xlsx')

files.reject! { |file_name| File.basename(file_name) =~ /^~/ }

files.each do |file_name|
  process_file(file_name)
end
