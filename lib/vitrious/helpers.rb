module Vitrious
  module Helpers
    def x(string)
      return "XXX #{strin} XXX"
    end
    
    def short( hash_to_short )
      hash_to_short.each_key.sort.map{ |e| hash_to_short[e] }
    end
  end
end