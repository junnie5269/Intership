class User< ActiveRecord::Base

self.table_name = "csosclientmetadata"


	def owner
	    self[:id].split("@")[-1] if self[:id]
	end

	def version
	    self[:version].split(".").map{ |v| v.to_i}.join(".")   if self[:version]
	end

	def preview?
    	self[:app_id].eql? "{af0a6f72-a618-4b99-ab91-fd54ecf1c997}"
    end

end