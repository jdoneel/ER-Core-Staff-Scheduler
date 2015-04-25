class ShiftsController < ApplicationController
  include Calendar
  def index
    @shifts = Shift.all
    @hours_per_person = show_hours_per_person
  end

  def new
  end

  def show
    @shift = Shift.find params[:id]
  end

  def edit
    @shift = Shift.find params[:id]
  end

  def create
    @shift = Shift.create!(params[:shift])
    offset = params[:length]
    new_shiftend = @shift.shiftstart + offset[:length].to_i.hours
    @shift.update_attribute(:shiftend, new_shiftend.to_datetime)
    flash[:notice] = "Shift was successfully created."
    #if  == nil
    #  raise Exception, "Not working"
    #else
    #raise Exception, "Is Working " + offset[:length].to_s + "\n Adding end:" +  @shift.shiftend.strftime("%Y/%m/%d - %H:%M") 
    #end
    dt_start = @shift.shiftstart
    dt_end = @shift.shiftend
    dt_doc = @shift.owner
    gcal_event_insert(0, dt_doc, "core", dt_start, dt_end, @shift.event_id)
    @shift.ingcal = true
    @shift.save!
    redirect_to shifts_path
  end
  
  def update
    @shift = Shift.find params[:id] 
    old_start = @shift.shiftstart
    old_user = @shift.owner
    if old_user == '***' || old_user == ""
      delete_id = 0
    else
      delete_id = User.find_by_first_name(old_user).id
    end
    @shift.update_attributes!(params[:shift])
    dt_start = @shift.shiftstart
    dt_end = @shift.shiftend
    dt_doc = @shift.owner
    if dt_doc == "" || dt_doc.nil?
      dt_doc = "***"
      @shift.update_attribute(:owner, '***')
    end
    if (!@shift.users.nil? || !@shift.possible_users.nil?) &&(dt_doc != "***")
      gcal_event_update(User.find_by_first_name(dt_doc).id, dt_doc, "core", dt_start, dt_end, @shift.event_id)
    else
      gcal_event_update(0, dt_doc, "core", dt_start, dt_end, @shift.event_id)
    end
    flash[:notice] = "Shift was successfully updated."
    redirect_to shift_path(@shift)
  end

  def destroy
    @shift = Shift.find(params[:id])
    dt_start = @shift.shiftstart
    if @shift.owner == '***' || @shift.owner == "" || @shift.owner.nil? || @shift.owner == " "
      gcal_event_delete(@shift.event_id)
    else
      dt_doc = @shift.owner
      gcal_event_delete(@shift.event_id)
    end
    @shift.destroy
    flash[:notice] = "Shift deleted."
    redirect_to shifts_path
  end

  def show_hours_per_person
    users = User.all
    hours_per_person = {"***" => [0, 0]}
    users.each do |user|
      full_name = "#{user.first_name}"
      hours_per_person[full_name] = [0, (user.fte*80).to_i]
    end
    shifts = Shift.all
    shifts.each do |shift|
      if shift.shiftstart == nil
        raise Exception, "start Not working \n Adding end:" +  @shift.shiftend.strftime("%Y/%m/%d - %H:%M") 
      elsif shift.shiftend == nil
        raise Exception, "Not Working \n Adding end:" +  @shift.shiftend.strftime("%Y/%m/%d - %H:%M") 
      end
      if hours_per_person.has_key?(shift.owner)
        hours_per_person[shift.owner][0] = hours_per_person[shift.owner][0] + ((shift.shiftend - shift.shiftstart)/(60*60)).to_i
      else
        hours_per_person[shift.owner] = [((shift.shiftend - shift.shiftstart)/(60*60)).to_i, 0]      
      end
    end
    return hours_per_person
  end
end
