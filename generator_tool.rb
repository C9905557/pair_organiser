require './lib/pairer'
require './lib/pairerjp'
require 'pp'

rerun = true
start = 28
fin = 36

def valid_pairs? pair_arar, name_count
  h = {}
  if pair_arar.length != name_count-1
    p "Invalid set, expected partition count: #{name_count-1}, provided: #{pair_arar.length}" 
    return false
  end
  pair_arar.each do |ar1|
    if ar1.length != name_count/2
      pp "Invalid set, expected pair count: #{name_count/2}, provided: #{ar1.length}", ar1
      return
    end
    ar1.each do |ar2|
      if ar2.length != 2
        pp "Invalid set, bad pair length: #{ar2.length}, pair: #{ar2}, partition: ", ar1 
        return false 
      end
      if ar2[0] == ar2[1]
        pp "Invalid set, pair members identicals: #{ar2.length}, pair: #{ar2}, partition: ", ar1 
        return false 
      end
      key = ar2.join
      if h.has_key? key
        pp "Invalid set, duplicate pair: #{ar2.length}, pair: #{ar2}, partition: ", ar1 
        return false 
      end
      h[key] = true
    end
  end
  return true
end

unless rerun
  File.open("generated.rb", "w") do |f|
    f.write "partitions = Hash.new\n"
  end
end

(start..fin).step(2) do |n|
  list = Array.new(n) { |i| "X#{i}"}
  #pairer = Pairer.new list
  pairer = Pairerjp.new list
  start_time = Time.now
  partitions_ar = pairer.run
  p "Number of names: #{n}, partitions size #{partitions_ar.length}, Execution time: #{Time.now-start_time}"
  break unless valid_pairs? partitions_ar, n
  valid_pairs? partitions_ar, n
  partitions = PP.pp(partitions_ar, '', 400)
  partitions.gsub!(/"/, '')
  partitions.gsub!(/X/, '')
  partitions.gsub!(/ => /, '')

  File.open("generated.rb", "a") do |f|
    f.write "partitions[#{n}] =\n#{partitions}"
  end

end