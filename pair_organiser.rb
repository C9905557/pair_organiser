require './lib/pairer'
require './lib/pairerjp'
require 'pp'

big_list = Array.new(24) { |i| "Name#{i}"}

def valid_pairs? pair_arar, name_count
  h = {}
  return "Invalid set, expected partition count: #{name_count-1}, provided: #{pair_arar.length}" if pair_arar.length != name_count-1
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

pairer = Pairer.new %w{Pablo Dan Andrew Tom Rob Jay Norm Yev}
pp pairer.run


pairer_big = Pairer.new big_list
p "Running pairer_big"
start_time = Time.now
big_pairs = pairer_big.run
p "Execution time: #{Time.now-start_time}"
p  valid_pairs?(big_pairs, big_list.length) ? "*** Returned set is valid" : "!!! Returned set is INVALID"

pairerjp = Pairerjp.new %w{Pablo Dan Andrew Tom Rob Jay Norm Yev}
pp pairerjp.run

pairerjp_big = Pairerjp.new big_list
p "Running pairerjp_big"
start_time = Time.now
big_pairs_jp = pairerjp_big.run
p "Execution time: #{Time.now-start_time}"
p  valid_pairs?(big_pairs, big_list.length) ? "*** Returned set is valid" : "!!! Returned set is INVALID"
