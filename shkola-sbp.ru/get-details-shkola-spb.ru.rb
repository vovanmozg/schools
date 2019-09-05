# Скачивает детальную информацию о школах с сайта shkola-spb.ru

require 'csv'
require 'open-uri'
require 'set'

INPUT_FILE = "./data/shkola-spb.ru/schools-parsed-schkola.sbp.ru.csv"
PROXY = URI.parse("http://127.0.0.1:8118")

def process_csv(file)
  lines = file.readlines()
  lines.shift
  lines.each do |row|

    href = row[1]
    href.gsub!('../..', '')

    url = "https://shkola-spb.ru/#{href}"
    file_name = "./data/#{href.gsub(/[^a-zA-Z0-9]/,'')}.htm"

    if File.exists?(file_name)
      print '-'
      next 
    end

    print '+'
    

    tries = 3

    begin
      p url
      #fh = open(url, redirect: false, proxy: PROXY)
      fh = open(url, redirect: false)
      html = fh.read
      IO.write(file_name, html)
    rescue OpenURI::HTTPRedirect => redirect
      url = redirect.uri # assigned from the "Location" response header
      retry if (tries -= 1) > 0
      raiset
    end



    
    

    # fh = open(url) do |fh|
    #   html = fh.read
    #   IO.write(file_name, html)
    # end
    
  end
  
  puts 
  #break
end

# прочитать урлы школы, скачанные с shkola-spb.ru
file = CSV.open(INPUT_FILE, 'r')
process_csv(file)
file.close


