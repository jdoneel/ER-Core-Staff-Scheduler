#require 'uri'
#require 'cgi'
#require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
#require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

#module WithinHelpers
#  def with_scope(locator)
#    locator ? within(*selector_for(locator)) { yield } : yield
#  end
#end
#World(WithinHelpers)

include Calendar

Given /that I am signed in/ do
end


And /I am an admin user/ do
end

And /I follow edit for shift (.+)/ do |e1|
	visit shift_path(e1)
end

Then /I should see a (.+) labeled (.+)/ do |e1, e2|
	if e2 =~ /ShiftStart/ or e2 =~ /ShiftEnd/
		assert e1 =~ /datetime_select/
	elsif e2 =~ /Save/
		assert e1 =~ /submit_tag/
	end
end

Then /I should see the shifts added to the page/ do
	Shift.all.each do |shift|
		Calendar.gcal_event_delete(shift.event_id)
	end
end

Then /the shifts should be deleted/ do
	Shift.all.each do |shift|
		Calendar.gcal_event_delete(shift.event_id)
	end
end


When /I add a shift for (.+) - (.+) from (.+) to (.+)/ do |mon, day, shftst, shftend|
	formStart = DateTime.iso8601('2015-'+mon+'-'+day+'T'+shftst+':00')
	formEnd = DateTime.iso8601('2015-'+mon+'-'+day+'T'+shftend+':00')
	shift = Shift.new
	shift.owner = '***'
	shift.shiftstart = formStart
	shift.shiftend = formEnd
	shift.event_id = 1
	Calendar.gcal_event_insert(0, shift)
end

Then /^(?:|I )should be redirected to the edit page for shift (.+)$/ do |shift|
  visit edit_shift_path(shift)
end


And /I fill in the date select field labeled "(.+)" with (.+)/ do |e1, e2|
	if e2 =~ /Start/ or e2 =~ /End/
		assert e1 =~ /datetime_select/
	elsif e2 =~ /Save/
		assert e1 =~ /submit_tag/
	end
end

Then /I fill in time (.+) with (.+)-(.+)-(.+)-(.+)-(.+)/ do |field ,year, month, day, hour, minute|
  select(year,   :from => "shift_#{field}_1i")
  select(month,  :from => "shift_#{field}_2i")
  select(day,    :from => "shift_#{field}_3i")
  select(hour,   :from => "shift_#{field}_4i")
  select(minute, :from => "shift_#{field}_5i")
end

And /I should see one time (.+) is "(.+)"/ do |field, time|
	page should have_content(time)
end

Then /I should delete the shift for (.+) - (.+) starting at (.+) from google/ do |mon, day, start|
	formStart = DateTime.iso8601('2015-'+mon+'-'+day+'T'+start+':00')
	Calendar.gcal_event_delete(1)
end

And /I should see one (.*) is (.*)/ do |e1, e2|
	page.should have_content(e2)
end

