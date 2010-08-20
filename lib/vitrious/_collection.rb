module Vitrious
  class Collection
    attr_accessor :title, :items
    
    def initialize( opts={} )
      @title = opts[:title] || "no title"
      @items = []
    end
  end
end