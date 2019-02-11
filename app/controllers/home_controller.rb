class HomeController < ApplicationController
  def dashboard
    @data = DashboardDataService.new(current_user) if current_user
  end
end
