require 'pg'

class SitesController < ApplicationController

   def index
     @sites = Site.summary
   end

   def show
      @clients = Client.select("distinct *")
            .where("audit_update_date >= (select max(audit_update_date) from csosclientmetadata as m2 where m2.id = csosclientmetadata.id)")
            .where(site: params[:id])
            .where("version is not null")
   end
   
end
