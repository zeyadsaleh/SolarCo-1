class SystemsController < ApplicationController
  before_action :set_system, only: [:show, :update, :destroy]

  # GET /systems
  def index
    @systems = System.all

    render json: @systems
  end

  # GET /systems/1
  def show
    render json: @system
  end

  # POST /systems
  def create
    if params[:lat] && params[:long]
      res_loc = (Geocoder.search([params[:lat], params[:long]])[0].data).to_hash

      @system = System.create(latitude: params[:lat].to_f, longitude: params[:long].to_f, consumption: params[:consump], city: res_loc['address']['city'],country: res_loc['address']['country'],road: res_loc['address']['road'], neighbourhood: res_loc['address']['neighbourhood'], hamlet: res_loc['address']['hamlet'], user_id: 1)
    else
      res_ip = (Geocoder.search(params[:ip])[0].data).to_hash
      loc = res_ip['loc'].split(',') unless res_ip['loc'].nil?

      @system = System.create(latitude: loc[0].to_f, longitude: loc[1].to_f, consumption: params[:consump], city: res_ip['region'],country: res_ip['country'], user_id: 1)
    end

    if @system.save
      render json: @system, status: :created
    else
      render json: @system.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /systems/1
  def update
    if @system.update(system_params)
      render json: @system
    else
      render json: @system.errors, status: :unprocessable_entity
    end
  end

  # DELETE /systems/1
  def destroy
    @system.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system
      @system = System.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_params
      params.require(:system).permit()
    end
end
