class ExtraHolidaysController < ApplicationController
  before_action :require_admin
  before_action :set_extra_holiday, only: [:show, :edit, :update, :destroy]

  # GET /extra_holidays
  # GET /extra_holidays.json
  def index
    @extra_holidays = ExtraHoliday.all
  end

  # GET /extra_holidays/1
  # GET /extra_holidays/1.json
  def show
  end

  # GET /extra_holidays/new
  def new
    @extra_holiday = ExtraHoliday.new
  end

  # GET /extra_holidays/1/edit
  def edit
  end

  # POST /extra_holidays
  # POST /extra_holidays.json
  def create
    @extra_holiday = ExtraHoliday.new(extra_holiday_params)

    respond_to do |format|
      if @extra_holiday.save
        format.html { redirect_to @extra_holiday, notice: 'Extra holiday was successfully created.' }
        format.json { render :show, status: :created, location: @extra_holiday }
      else
        format.html { render :new }
        format.json { render json: @extra_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /extra_holidays/1
  # PATCH/PUT /extra_holidays/1.json
  def update
    respond_to do |format|
      if @extra_holiday.update(extra_holiday_params)
        format.html { redirect_to @extra_holiday, notice: 'Extra holiday was successfully updated.' }
        format.json { render :show, status: :ok, location: @extra_holiday }
      else
        format.html { render :edit }
        format.json { render json: @extra_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /extra_holidays/1
  # DELETE /extra_holidays/1.json
  def destroy
    @extra_holiday.destroy
    respond_to do |format|
      format.html { redirect_to extra_holidays_url, notice: 'Extra holiday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extra_holiday
      @extra_holiday = ExtraHoliday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def extra_holiday_params
      params.require(:extra_holiday).permit(:title, :description, :is_hourly, :is_comment_required, :is_paid, :is_as_attended)
    end
end
