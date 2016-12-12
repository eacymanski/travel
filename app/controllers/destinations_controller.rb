class DestinationsController < ApplicationController
  include DestinationsHelper
  before_action :set_destination, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @current_trip = params[:trip_id]
    @destination = Destination.new
  end

  def edit
  end

  def create
    create_params = destination_params.merge \
      latitude: google_api.latitude,
      longitude: google_api.longitude,
      picture: google_api.photo_url
    destination = Destination.new(create_params)
    if destination.save
      render :show, destination.id
    else
      render :new
    end
    google_api.get_distances(id)
  end

  def update
    respond_to do |format|
      if @destination.update(destination_params)
        format.html { redirect_to @destination, notice: 'Destination was successfully updated.' }
        format.json { render :show, status: :ok, location: @destination }
      else
        format.html { render :edit }
        format.json { render json: @destination.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    removeDistance(@destination)
    @destination.destroy
    respond_to do |format|
      format.html { redirect_to destinations_url, notice: 'Destination was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_destination
    @destination = Destination.find(params[:id])
  end

  def destination_params
    params.require(:destination).permit(:city, :state, :picture, :trip_id)
  end

  def google_api
    @google_api ||= GoogleApi.new(destination_params[:city], destination_params[:state])
  end
end
