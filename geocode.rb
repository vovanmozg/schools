require('open-uri')
require('csv')
require('awesome_print')
require('digest')

require('./files')


def start
  CSV.open(NAMES, 'r', headers: true) do |file|
    file.read.each do |line|
      p line['name']
      process(line)
    end
  end
end

def process(line)
  return if File.exist?(file_name(line))

  content = download_content(line['name'])

  IO.write(file_name(line), content)
end

def download_content(title)
  url = "https://geocode-maps.yandex.ru/1.x/?apikey=#{KEY}&format=json&kind=house&geocode=#{title} Санкт-Петербург"
  open(URI::encode(url)) do |fh|
    return fh.read
  end
end


def file_name(line)
  "./data/downloaded/geocoder/#{line['id']}_#{Digest::MD5.hexdigest(line['name'])}.json"
end


start