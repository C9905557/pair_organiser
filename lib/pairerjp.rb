class Pairerjp
  def initialize list
    @list = list
    @n_names = list.length
    @number_pairs = list.length / 2
    @used_pairs = Array.new
    (0..@n_names).each { |i| @used_pairs[i] = Array.new(@n_names, false) }
  end

  def run
    set = []
    # Loop over the columns
    (1..n_names-1).each do |cix|
    #(n_names-1).downto(1) do |cix|
      p "Run -- cix #{cix}"
      pairs = []
      pairs << [0,cix]
      # Loop over the rows
      selected_ixes = Array.new n_names, false
      selected_ixes[cix] = true
      pairs = find_pairs pairs, 1, selected_ixes
      if pairs.length != number_pairs 
        p "*** Bad partition, length #{pairs.length} for column #{cix}"
        return []
      end
      pairs.each { |x, y| used_pairs[x][y] = true }
      set << pairs
    end
    set.map { |a1| a1.map { |a2| a2.map {|i| list[i]} } } 
  end
        
  private

  attr_reader :number_pairs, :list, :n_names
  attr_accessor :used_pairs
  
  def find_pairs pairs, rix, selected_ixes
    # Skip to next row if incompatible with indexes already selected
    if selected_ixes[rix]
      return find_pairs pairs, rix+1, selected_ixes if rix < n_names-2
      return pairs
    end
    # Skip if there are not enough rows to get the remaining indexes
    return pairs if n_names-1-rix < number_pairs - pairs.length
    # loop to find pairs in rows
    (rix+1..n_names-1).each do |c|
      #p "fp rix #{rix} c #{c} #pairs #{pairs.length} selected #{selected_ixes}"
      if pair_valid? rix, c, selected_ixes
        # my_pairs = pairs.dup
        # my_selected_ixes = selected_ixes.dup
        # my_selected_ixes = my_selected_ixes + [rix,c]
        # my_pairs << [rix,c]
        # return my_pairs if my_pairs.length == number_pairs
        # if rix < n_names-2
        #   my_pairs = find_pairs my_pairs, rix+1, my_selected_ixes
        #   return my_pairs if my_pairs.length == number_pairs
        # end
        selected_ixes[rix] = true
        selected_ixes[c] = true
        pairs.push [rix,c]
        return pairs if pairs.length == number_pairs
        if rix < n_names-2
          pairs = find_pairs pairs, rix+1, selected_ixes
          return pairs if pairs.length == number_pairs
        end
        # One path did not work, continue with next path
        # Backtrack!
        selected_ixes[rix] = false
        selected_ixes[c] = false
        pairs.pop
      end
    end
    # No valid pairs found, comtinue with next row
    return find_pairs pairs, rix+1, selected_ixes if rix < n_names-2
    pairs
  end
      
        
  def pair_valid? rix, c, selected_ixes
    return false if used_pairs[rix][c]
    return false if selected_ixes[c]
    true
  end
    
end
