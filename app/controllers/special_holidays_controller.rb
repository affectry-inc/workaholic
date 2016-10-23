class SpecialHolidaysController < ApplicationController
  before_action :require_admin
  before_action :set_special_holiday, only: [:show, :edit, :update, :destroy]

  # GET /special_holidays
  # GET /special_holidays.json
  def index
    @special_holidays = SpecialHoliday.all
  end

  # GET /special_holidays/1
  # GET /special_holidays/1.json
  def show
  end

  # GET /special_holidays/new
  def new
    @special_holiday = SpecialHoliday.new
  end

  # GET /special_holidays/1/edit
  def edit
  end

  # POST /special_holidays
  # POST /special_holidays.json
  def create
    @special_holiday = SpecialHoliday.new(special_holiday_params)

    respond_to do |format|
      if @special_holiday.save
        format.html { redirect_to @special_holiday, notice: 'Special holiday was successfully created.' }
        format.json { render :show, status: :created, location: @special_holiday }
      else
        format.html { render :new }
        format.json { render json: @special_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /special_holidays/1
  # PATCH/PUT /special_holidays/1.json
  def update
    respond_to do |format|
      if @special_holiday.update(special_holiday_params)
        format.html { redirect_to @special_holiday, notice: 'Special holiday was successfully updated.' }
        format.json { render :show, status: :ok, location: @special_holiday }
      else
        format.html { render :edit }
        format.json { render json: @special_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /special_holidays/1
  # DELETE /special_holidays/1.json
  def destroy
    @special_holiday.destroy
    respond_to do |format|
      format.html { redirect_to special_holidays_url, notice: 'Special holiday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_special_holiday
      @special_holiday = SpecialHoliday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def special_holiday_params
      params.require(:special_holiday).permit(:title, :description, :special_holiday_ctgr_id, :is_paid, :is_as_attended)
    end
end
