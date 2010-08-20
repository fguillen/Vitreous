module Vitrious
  class Item
    attr_accessor :title, :description, :url
    
    def initialize( opts={} )
      @title = opts[:title] || 'no title'
      @url = opts[:url] || 'no url'
      @description = opts[:description] || nil
    end
  end
end