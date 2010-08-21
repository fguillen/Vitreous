require "#{File.dirname(__FILE__)}/vitrious_app.rb"


# Initialize de config.yml
#
# I know there is a lot of staff into ENV variable
# but there is a very small possibility this could be a problem.
#
# Use: rake config dropbox_consumer_key='CONSUMER KEY' dropbox_consumer_secret='CONSUMER SECRET'
task :config do
  Vitrious::Configurator.do( ENV )
end

