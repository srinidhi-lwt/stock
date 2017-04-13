require 'rubygems'
require 'mechanize'

class WelcomeController < ApplicationController

	def index
		@revenue = params[:revenue] if params[:revenue].present?
		@company_name = params[:company] if params[:company].present?
	end

	def search_results
		byebug
		agent = Mechanize.new
		company_name = params[:search_string]
		page = agent.get("http://www.google.com?q=#{company_name}+revenue")
		form = page.form_with(:action => '/search')
		search_results = form.submit
		revenue = search_results.at('.g').children.text
		redirect_to root_path(company: company_name,revenue: revenue)
	end
end


