class ScheduledEventsController < ApplicationController
  before_action :set_scheduled_event, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scheduled_events = ScheduledEvent.all
    respond_with(@scheduled_events)
  end

  def show
    respond_with(@scheduled_event)
  end

  def new
    @scheduled_event = ScheduledEvent.new
    respond_with(@scheduled_event)
  end

  def edit
  end

  def create
    @scheduled_event = ScheduledEvent.new(scheduled_event_params)
    @scheduled_event.save
    respond_with(@scheduled_event)
  end

  def update
    @scheduled_event.update(scheduled_event_params)
    respond_with(@scheduled_event)
  end

  def destroy
    @scheduled_event.destroy
    respond_with(@scheduled_event)
  end

  private
    def set_scheduled_event
      @scheduled_event = ScheduledEvent.find(params[:id])
    end

    def scheduled_event_params
      params[:scheduled_event]
    end
end
