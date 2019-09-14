#require 'roo'
#require 'roo-xls'

#require 'spreadsheet'
require 'roo'
require 'awesome_print'
require 'rchardet'

#fname = '/Users/vovanmozg/Yandex.Disk-vovanmozg2.localized/школы/39/samobsledovanie_2018.xls'
fname = '/media/sda/yandex_disk/школы/262/262-1.xlsx'

#xls = Spreadsheet.open(fname) and true
xls = Roo::Spreadsheet.open(fname)

sheets = xls.worksheets #('Sheet1')


sheets[0].rows.each do |row|
	#p row.to_s.force_encoding("ascii").encode("UTF-8")
	p row.to_s#.encode("UTF-16") #.encode("windows-1251")
	#p CharDet.detect(row.to_s)
end

# sheet.each do |hash|
#   puts hash
#   # => { id: 1, name: 'John Smith' }
# end

#IO.write('./tmp/1.txt', out.to_s)

