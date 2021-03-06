Feature: Display Current Schedule
	As a User
	So that I can see this pay-period's schedule
	I want to see the current pay-period on the calendar for my shifts

Background: Given I have been added to the database
	
	Given 'admin' has been added to the database
	Given I am logged in as 'admin' with password 'admin'
	When I go to the verified page
  	Then I press "Update"
	And I go to the home page
	Then I should be on the home page

Scenario: User can see calendar for two payment periods
	Then I should see the schedule for two payment periods