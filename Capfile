# SERVER       = "gg2"
SERVER       = "r210x.com"
APPDIR       = "BAMRU-Private"

set :application, "BAMRU-Private"

load 'deploy' if respond_to?(:namespace)
Dir['vendor/plugins/*/recipes/*.rb'].each { |p| load p }
Dir['lib/shared/recipes/*.rb'].each { |p| load p }

