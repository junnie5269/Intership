class Audit < ActiveRecord::Base
  self.table_name = "csos_audit"
  self.primary_key  = "id"
  self.inheritance_column = :_type_disabled

  def username
    self[:id].split(":")[-1].split("@")[0] if self[:id]
  end

  def owner
    self[:id].split("@")[-1] if self[:id]
  end

  def version
    self[:version].split(".").map{ |v| v.to_i}.join(".")  
  end

end

