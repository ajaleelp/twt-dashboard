class HomeController < ApplicationController
  def dashboard
    @data = DashboardDataService.new(params[:screen_name]) if params[:screen_name]
  end
end
