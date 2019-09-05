# schools
Информация о школах Санкт-Петербурга



# data
schools-schkola.spb.ru-with-id.csv
Файл содержит спарсенную детальную информацию о школах с сайта shkola-spb.ru с добавленной колонкой main_id (ОГРН)
генерируется скриптом combine-names.rb из файлов
- names.csv
- petersburgedu.ru-full.csv
- shkolaspb-orgn-manual.csv
- shkola-spb.ru/schools-schkola.spb.ru.csv


shkola-spb.ru/schools-schkola.spb.ru.csv
Файл содержит спарсенную детальную информацию о школах с сайта shkola-spb.ru + краткую инфу с shkola-spb.ru
генерируется скриптом shkola-sbv.ru/combine.rb из файлов:
- shkola-spb.ru/schools-parsed-schkola.spb.ru.csv
- shkola-spb.ru/schools-parsed-detail-schkola.spb.ru.csv


shkolaspb-orgn-manual.csv
Вручную установлены соответствия между идентификатором школы на сайте shkola-spb.ru и ОГРН

ids-for-not-found-schools.csv
Взяли список школ с shola-sbp.ru, для каждой школы нашли сопоставление из petersburgedu.ru чтобы определить 
огрн. Школы, для которых не получилось найти аналог из petersburgedu.ru попали в этот список. Потом сюда
руками добавили  глобальный идентификатор.