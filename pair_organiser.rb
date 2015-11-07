require './lib/pairer'
require './lib/pairerjp'
require 'pp'

big_list = Array.new(20) { |i| "Name#{i}"}

def valid_pairs? pair_arar, name_count
  h = {}
  return false if pair_arar.length != name_count-1
  pair_arar.each do |ar1|
    return false if ar1.length != name_count/2
    ar1.each do |ar2|
      return false if ar2.length != 2
      return false if ar2[0] == ar2[1]
      key = ar2.join
      return false if h.has_key? key
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
