class SpecialHolidayCtgrsController < ApplicationController
  before_action :require_admin
  before_action :set_special_holiday_ctgr, only: [:show, :edit, :update, :destroy]

  # GET /special_holiday_ctgrs
  # GET /special_holiday_ctgrs.json
  def index
    @special_holiday_ctgrs = SpecialHolidayCtgr.all
  end

  # GET /special_holiday_ctgrs/1
  # GET /special_holiday_ctgrs/1.json
  def show
  end

  # GET /special_holiday_ctgrs/new
  def new
    @special_holiday_ctgr = SpecialHolidayCtgr.new
  end

  # GET /special_holiday_ctgrs/1/edit
  def edit
  end

  # POST /special_holiday_ctgrs
  # POST /special_holiday_ctgrs.json
  def create
    @special_holiday_ctgr = SpecialHolidayCtgr.new(special_holiday_ctgr_params)

    respond_to do |format|
      if @special_holiday_ctgr.save
        format.html { redirect_to @special_holiday_ctgr, notice: 'Special holiday ctgr was successfully created.' }
        format.json { render :show, status: :created, location: @special_holiday_ctgr }
      else
        format.html { render :new }
        format.json { render json: @special_holiday_ctgr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /special_holiday_ctgrs/1
  # PATCH/PUT /special_holiday_ctgrs/1.json
  def update
    respond_to do |format|
      if @special_holiday_ctgr.update(special_holiday_ctgr_params)
        format.html { redirect_to @special_holiday_ctgr, notice: 'Special holiday ctgr was successfully updated.' }
        format.json { render :show, status: :ok, location: @special_holiday_ctgr }
      else
        format.html { render :edit }
        format.json { render json: @special_holiday_ctgr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /special_holiday_ctgrs/1
  # DELETE /special_holiday_ctgrs/1.json
  def destroy
    @special_holiday_ctgr.destroy
    respond_to do |format|
      format.html { redirect_to special_holiday_ctgrs_url, notice: 'Special holiday ctgr was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_holiday_ctgr
      @special_holiday_ctgr = SpecialHolidayCtgr.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def special_holiday_ctgr_params
      params.require(:special_holiday_ctgr).permit(:title)
    end
end
