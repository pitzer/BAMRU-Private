class Eapi::Events::EventLinksController < ApplicationController
  respond_to :json

  before_filter :authenticate_member_with_basic_auth!

  def index
    event = Event.find(params["event_id"])
    respond_with event.event_links, opts
  end
  
  def show
    respond_with EventLink.find(params[:id])
  end
  
  def create
    render :json => EventLink.create(params[:event_link])
  end
  
  def update
    respond_with EventLink.update(params[:id], params[:event_link])
  end
  
  def destroy
    respond_with EventLink.destroy(params[:id])
  end

  private

  def opts
    {except: [:created_at]}
  end

end