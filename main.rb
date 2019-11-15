require_relative 'lib/piwigo/session'

puts "BEGIN"
session = Piwigo::Session.new
session.login('10.100.230.78', 'Adrian', 'secret', https: false)
session.logout

puts "END"