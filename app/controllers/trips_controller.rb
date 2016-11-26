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
    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'trip was successfully created.' }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
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
