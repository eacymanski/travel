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
    @destination = Destination.new(create_params)
    if @destination.save
      redirect_to destination_path(@destination)
    else
      render :new
    end
    create_distances
  end

  def update
    if @destination.update(destination_params)
      redirect_to @destination
    else
      render :edit
    end
  end

  def destroy
    trip = @destination.trip_id
    removeDistance(@destination)
    @destination.destroy
    redirect_to trip_path(trip)
  end

  private

  def set_destination
    @destination = Destination.find(params[:id])
  end

  def destination_params
    params.require(:destination).permit(:city, :state, :picture, :trip_id)
  end

  def create_params
    destination_params.merge \
      latitude: google_api.latitude,
      longitude: google_api.longitude,
      picture: google_api.photo_url
  end

  def google_api
    @google_api ||= GoogleApi.new(destination_params[:city],
                                  destination_params[:state])
  end

  def create_distances
    return if other_destinations.empty?
    results = google_api.distance_results(other_destinations)
    results.each_with_index do |result, i|
      create_distance(result, other_destinations[i])
    end
  end

  def other_destinations
    @other_destinations ||= Destination.where('id != ?', @destination.id)
  end

  def create_distance(result, other_destination)
    @destination.city_distances.create(
      final_destination: other_destination,
      distance: result['distance']['value']
    )
    other_destination.city_distances.create(
      final_destination: @destination,
      distance: result['distance']['value']
    )
  end

  def remove_distances
    Destination.all.each do |des|
      if des != destination
        to_destroy = des.city_distances.where(final_destination: destination)
        to_destroy.destroy_all
      end
    end
  end
end
