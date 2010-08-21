module Vitrious
  class Configurator
    def self.do( opts={} )
      config = File.read( "#{Vitrious::Configurator.config_root_path}/config.yml.template" )
      opts.each_pair do |k,v|
        config.gsub!( "%#{k}%", v )
      end

      File.open( "#{Vitrious::Configurator.config_root_path}/config.yml", 'w' ) { |f| f.write config }

      puts File.read( "#{Vitrious::Configurator.config_root_path}/config.yml" )
    end
    
    def self.config_root_path
      return "#{File.dirname(__FILE__)}/../../config"
    end
  end
end