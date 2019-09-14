

# Сопоставление ID и ОГРН (только для школ с сайта petersburgedu). Нужно учитывать, что в будущем у школы может
# поменяться ОГРН, поэтому могут возникнуть проблемы с сопоставлением
OGRN_ID_PETERSBURGEDU = './data/manual/petersburgedu-id-ogrn.csv'

SHKOLASPBID_ORGN = './data/manual/shkolaspb-shkolasbpid-orgn.csv'

# Идентификаторы, сгенерированные для несопоставленных школ с сайта shkola-spb.ru
SHKOLASPB_ID_NOT_DETECTED = './data/manual/shkolaspb-partial-shkolaspbid-id.csv'

# школы из petersburgedu.ru, которые не попали в итоговый список
NOT_USED = './data/not_used.csv'

# школы из shkola.spb.ru, для которых не удалось найти сопоставления в petersburgedu.ru
NOT_FOUND = './data/not_found.csv'

# сопоставления имён школ (в разных написаниях) и идентификаторов
# помогает определить идентификатор школы по названию
NAMES = './data/generated/names.csv'

#Файл содержит спарсенную детальную информацию о школах с сайта shkola-spb.ru + краткую инфу с shkola-spb.ru
#генерируется скриптом shkola-sbv.ru/combine.rb из файлов SHKOLASPB_PARSED_COMPACT и SHKOLASPB_PARSED_DETAIL
SHKOLASPB = './data/generated/shkolaspb/schools.csv'

SHKOLASPB_WITH_ID = './data/generated/shkolaspb/schools-with-id.csv'

SHKOLASPB_PARSED_DETAIL = './data/downloaded/shkolaspb/schools-parsed-detail-schkola.spb.ru.csv'

SHKOLASPB_PARSED_COMPACT = './data/downloaded/shkolaspb/schools-parsed-schkola.spb.ru.csv'

# Информация по всем школам скачанная и спарсенная с сайта petersburgedu.ru
PETERSBURGEDU = './data/downloaded/petersburgedu/petersburgedu.ru-full.csv'

