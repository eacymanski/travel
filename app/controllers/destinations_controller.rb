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
    @destination = Destination.new(destination_params)

    respond_to do |format|
      if @destination.save
        format.html { redirect_to @destination, notice: 'Destination was successfully created.' }
        format.json { render :show, status: :created, location: @destination }
      else
        format.html { render :new }
        format.json { render json: @destination.errors, status: :unprocessable_entity }
      end
    end
    getDistances(@destination)
    @destination.updateLatLong
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

end
