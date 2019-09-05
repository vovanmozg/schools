# Достаёт подробную информацию о школах из контента спарсенного с petersburgedu.ru
# Работает на основе файлов, полученных с помощью get-details-pegerburgedu.ru.rb
require 'nokogiri'
require 'set'
require 'csv'

OUTPUT_FILE = './data/petersburgedu.ru-full.csv'

allowed_keys = [
  'Номер ОУ',
  'Полное наименование ОУ по Уставу',
  'Краткое наименование',
  'Адрес электронной почты',
  'Адрес ОУ',
  'Должность руководителя',
  'ФИО руководителя',
  'Тип ОУ',
  'Вид ОУ',
  'Телефон',
  'Район',
  'Подведомственность',
  '"Статус сервиса ""Электронный дневник"""',
  'ОГРН',
  'Адрес электронной почты из Параграф.Регион',
  'Адрес сайта в сети Интернет',
  'Название',
  'Адрес сайта',
  'Город',
  'Улица',
  'Дом',
  'Литерал',
  'Корпус',
  'Индекс',
  'Сайт инициализирован',
  'Сайт ОО',
  'Код здания ФИАС',
  'Тип местности',
  'Часы работы',
  'Юридический адрес через код здания ФИАС',
  'Организационно-правовая форма',
  'Статус',
  'Тип группы ОВЗ',
  'Тип питания',
  'Официальный сайт',
  'Старый ОГРН',
  'ОКТМО'
]

#keys = Set.new
schools = []

files = Dir.glob('./data/petersburgedu.ru/details/*.htm')

files.each do |file|
  print '.'
  html = IO.read(file)

  html_doc = Nokogiri::HTML(html)

  school = {}
  html_doc.css('.school-information > div.row').each do |div|

    key = div.css('> b').text.strip
    value = div.css('> div.value').text.strip

    key = 'Корпус' if key == 'корпус'
    key = 'Литера' if key == 'Литерал'

    #p "#{key} - #{value}"
    school[key] = value


    #keys << key
  end
  schools << school
end



CSV.open(OUTPUT_FILE, 'wb') do |file|
  file << allowed_keys
  schools.each do |school|
    print '.'
    values = []
    allowed_keys.each do |key|
      if school.key?(key)
        values << school[key]
      else
        values << ''
      end
    end

    file << values
  end
end
