class IndexController < ApplicationController

  def index
    @versions = Client.select("version, count(distinct id)")
          .where("audit_update_date >= dateadd(h, -24, getdate())")
          .where("version is not null")
          .group(:version)
          .order(:version)
  end
end
