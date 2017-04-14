require 'rubygems'
require 'mechanize'

class WelcomeController < ApplicationController
	COMPANY_FEATURES = {
		revenue: 'Get Revenue',
		info: 'Company Info'
	}

	def index
		@revenue = params[:revenue] if params[:revenue].present?
		@company_name = params[:company] if params[:company].present?
		@address = params[:address] if params[:address].present?
	end

	def search_results
		agent = Mechanize.new
		company_name = params[:search_string]
		if company_name.blank?
			flash[:notice] = 'Search String cannot be Empty'
			return redirect_to root_path
		end
		if params[:commit] == COMPANY_FEATURES[:revenue]
			page = agent.get("http://www.google.com?q=#{company_name}+revenue")
			form = page.form_with(:action => '/search')
			search_results = form.submit
			revenue = search_results.at('.g').children.text
			redirect_to root_path(company: company_name, revenue: revenue)
		else
			page = agent.get("http://www.google.com?q=technologies+used+by+#{company_name}")
			form = page.form_with(:action => '/search')
			search_results = form.submit
			address = search_results.at('.g').children.text
			redirect_to root_path(company: company_name, address: address)
		end
	end
end


