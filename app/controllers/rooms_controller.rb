class RoomsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    if params[:search].present?
    @rooms = Room.near(params[:search],50)
    else
    @rooms = Room.all
  end
end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @booking = Booking.new
    @reviews = @room.reviews
    @average_review = if @reviews.blank?
      0
    else
      @room.reviews.average(:rating)
  end
end

  # GET /rooms/new
  def new
    @room = current_user.rooms.build
  end

  # GET /rooms/1/edit
  def edit
    if current_user.id != @room.user.id
    redirect_to root_path, notice: "You don't have permission."
    end
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    @room.user_id = current_user.id if current_user
    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    if current_user.id == @room.user_id
     @room.destroy
      respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
   else
   redirect_to root_path, notice: "You don't have permission."
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit( :price, :host_name, :room_id, :room_name, :description, :country, :location, :bed, :bathroom, :capacity, :pets, :smoking, :wifi, :avatar, :user_id)
    end
  end
