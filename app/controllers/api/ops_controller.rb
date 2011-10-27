class Api::OpsController < ApplicationController

  respond_to :xml, :json

  before_filter :authenticate_member_with_basic_auth!

  # curl -u <first>_<last>:<pwd> http://server/api/ops/set_do.json
  def set_do
    Member.set_do
    render :json => "OK\n"
  end

  # curl -u <first>_<last>:<pwd> http://server/api/ops/message_cleanup.json
  def message_cleanup
    storage_limit = 100
    purge_count   = 0
    Message.order('id DESC').all.each_with_index do |msg, index|
      if index >= storage_limit
        msg.destroy
        purge_count += 1
      end
    end
    render :json => "OK (records purged: #{purge_count})\n"
  end

end