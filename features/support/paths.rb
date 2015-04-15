# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^home$/
      home_path
    when /^login$/
      login_path
    when /^signup$/
      sign_up_path
    when /^logout$/
      logout_path
    when /^forgot$/
      new_password_reset_path
    when /^availabilities$/
      availabilities_path
    when /^new password$/
      edit_password_reset_path User.first.password_reset_token

    #from admin-add-shifts 
    when /^input schedule$/
      new_shift_path
    when /^shift index$/
      shifts_path
    when /^not verified$/
      not_verified_path
    when /^verification complete$/
      verified_path
    when /^multiply$/
      multiply_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
