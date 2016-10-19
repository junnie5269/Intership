class UsersController < ApplicationController

	def index
        
    end

	def show
		params.permit!
		@users = User.select("id, version, audit_update_date, site, app_id ")
		         .where(last_logged_in_identity: params[:username].to_s )
		         .order('audit_update_date DESC')
		         .limit(10)		
	end

	

end