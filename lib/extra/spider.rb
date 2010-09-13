require 'mechanize'

module Extra
  class Spider
    def self.create_tree_from_XXX_dot_com
      structure = []
      
      agent = Mechanize.new
      agent.get( 'http://XXX.com')
      agent.page.search("div#menu div.container > ul").each do |ul|
        li_title = ul.search("li.section-title").first
        next  if li_title.nil?
        
        collection = {
          :title => li_title.text,
          :items => []
        }
        
        puts collection[:title]
        puts "-----"
        ul.search("li > a").each do |li|
          item_agent = Mechanize.new
          item_agent.get( li[:href] )

          title = li.text
          description_item = item_agent.page.search("div#content > div.container > p")
          description = description_item.nil? ? nil : description_item.text
          img = item_agent.page.search("div#content > div.container img").first[:src]

          item = {
            :title => title,
            :description => description,
            :img => img
          }
          
          puts item.to_yaml
          
          collection[:items] << item
        end
        
        structure << collection
      end
      
      File.open( "#{File.dirname(__FILE__)}/XXX_com.yml", 'w' ) { |f| f.write structure.to_yaml }
      puts structure.to_yaml
    end
    
    def self.digest_structure
      structure = YAML.load_file( "#{File.dirname(__FILE__)}/XXX_com.yml" )
      
      base_path = "#{File.dirname(__FILE__)}/Vitrious"
      FileUtils.rm_rf base_path
      
      structure.each do |collection|
        puts "collection: #{collection[:title]}"
        FileUtils.mkdir_p( "#{base_path}/#{collection[:title]}" )
        collection[:items].each_with_index do |item, index|
          File.open( "#{base_path}/#{collection[:title]}/#{"%03d" % (index*10)} #{item[:title]}.txt", 'w' ) do |f|
            f.write item[:description]
          end
          
          File.open( "#{base_path}/#{collection[:title]}/#{"%03d" % (index*10)} #{item[:title]}.jpg", 'w' ) do |f| 
            f.write Net::HTTP.get( URI.parse( item[:img] ) )
          end
        end
      end
    end
  end
end