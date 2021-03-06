require 'json'
require 'faye'

require Rails.root.to_s + "/lib/notifications_util"

event_list = /page|pgvw|ops|service|logout|login|password|rake/

ActiveSupport::Notifications.subscribe(event_list) do |*args|
  data = prep_data(args)
  write_log(data)
end
