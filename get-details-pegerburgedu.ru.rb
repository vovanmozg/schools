# Скачивает детальную информацию о школах с сайта peterburgedu.ru
# В качестве идентификатора используется ОГРН.
# Не удалось скачать информацию по следующим ОГРН:
#   1027809227059
#   1037825013720
#   1037843076005
#   1027802496776
#   1027806075912
#   1027807590150
#   1027800560358
#   1027810000000
#   1027810300160
#   1037831009710
#   1037835057561
#   1027807997562
#   1027807991584
#   1037816003686
#   1020801582929
#   1027801582939
#   102807583187
#   102807582967
#   102787593703
#   102780752461 -
#   102787577467 - ошибка. Правильный ОГРН 1027807577467
#   102780758402 - ошибка. Правильный ОГРН 1027807584023
#   Возможные причины: школа закрыта, школа объединина с другой, неверный ОГРН
require 'csv'
require 'open-uri'
require 'set'

# ogrn-from-peterbugredu.ru.txt - содержит ОГРН всех школ, скачаных
ogrns = IO.read('./data/ogrn-from-peterbugredu.ru.txt').split("\n").map(&:chomp).to_set

# прочитать все школы скачанные с data.gov.spb.ru
CSV.open('./data/data.gov.spb.ru-data-20190621T141553-structure-20161130T141543.csv', 'r') do |file|
  lines = file.readlines()
  lines.each do |line|
    if (line[10] =~ /(\d{13})/).nil?
      #p line
      next
    end

    ogrns << $1
  end
end

ogrns << '102807583187'
ogrns << '102807582967'
ogrns << '102787593703'
ogrns << '102780752461'
ogrns << '102787577467'
ogrns << '102780758402'


ogrns.each do |ogrn|
  url = "https://petersburgedu.ru/institution/content/details/UID/#{ogrn}/"
  file_name = "./data/petersburgedu.ru/details/#{ogrn}.htm"

  next if File.exists?(file_name)


  p url

  begin
    fh = open(url)
    html = fh.read

    IO.write(file_name, html)

    fh.close

  rescue OpenURI::HTTPError => err
    p err
  end

end

