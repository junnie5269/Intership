class Client < ActiveRecord::Base
  self.table_name = "csosclientmetadata"
  self.primary_key  = "id"

  def last_username
    self[:last_logged_in_identity].split(":")[-1] if self[:last_logged_in_identity]
  end

  def owner
    self[:last_logged_in_identity].split("@")[-1] if self[:last_logged_in_identity]
  end

  def version
    self[:version].split(".").map{ |v| v.to_i}.join(".")   if self[:version]
  end

  def preview?
    self[:app_id].eql? "{af0a6f72-a618-4b99-ab91-fd54ecf1c997}"
  end

end
