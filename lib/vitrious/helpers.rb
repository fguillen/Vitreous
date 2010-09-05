module Vitrious
  module Helpers
    def x(string)
      return "XXX #{strin} XXX"
    end
    
    def sort( hash_to_sort )
      hash_to_sort.each_key.sort.map{ |e| hash_to_sort[e] }
    end
  end
end