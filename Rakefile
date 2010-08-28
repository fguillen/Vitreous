
# Run tests
task :default do
  Dir["test/*test.rb"].sort.each { |test|  load test }
end

# Initialize de config.yml
#
# I know there is a lot of staff into ENV variable
# but there is a very small possibility this could be a problem.
#
# Use: rake config dropbox_consumer_key='CONSUMER KEY' dropbox_consumer_secret='CONSUMER SECRET' website_name='My Portfolio' pass='mypass'
task :config do
  require "#{File.dirname(__FILE__)}/lib/vitrious/configurator"
  Vitrious::Configurator.do( ENV )
end

