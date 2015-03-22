require 'set'


db_name = Set.new
File.open("Prenoms.txt") do |file|
    file.gets
    while line = file.gets
        fline = line.split("|")[0]
        if fline =~ / \(\d+\)/
            fline = fline.split("(")[0]
        end
        db_name.add(fline)
    end
end


File.open("name_format.txt", "w") do | f |
    db_name.each do | name |
        f.puts name
    end
end

p db_name
