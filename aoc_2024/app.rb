APP_ROOT = __dir__

Dir['./lib/days/*.rb'].each { |f| require f } # allows us to require any class within the lib/days directory