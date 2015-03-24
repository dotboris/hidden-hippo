require 'set'
require 'pathname'

def format(line)
  fline = line.chomp.split("|")[0]
  if fline =~ / \(\d+\)/
    fline = fline.split("(")[0]
  end
  fline
end


txt_name = Pathname.new 'Prenoms.txt'
db_name = txt_name.readlines.map{|line| format(line)}


File.open("name_format.txt", "w") do |f|
    f.puts db_name[1,db_name.size]
end
