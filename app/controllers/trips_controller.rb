class TripsController < ApplicationController
  before_action :set_trip, except: [:new, :create, :index]
  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to @trip
    else
      render :new
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:title)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end
end
