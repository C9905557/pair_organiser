require './lib/pairer'
require 'pp'

start = 8
fin = 24

File.open("generated.rb", "w") do |f|
  f.write "partitions = Hash.new\n"
end

(start..fin).step(2) do |n|
  list = Array.new(n) { |i| "X#{i}"}
  pairer = Pairer.new list
  partitions_ar = pairer.run
  p "Number of names: #{n}, partitions size #{partitions_ar.length}"

  partitions = PP.pp(partitions_ar, '', 200)
  partitions.gsub!(/"/, '')
  partitions.gsub!(/X/, '')
  partitions.gsub!(/ => /, '')

  File.open("generated.rb", "a") do |f|
    f.write "partitions[#{n}] =\n#{partitions}"
  end

end