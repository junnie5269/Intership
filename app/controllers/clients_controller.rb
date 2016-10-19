require 'pg'
require 'aws-sdk-for-ruby'

class ClientsController < ApplicationController
  
   def index
   end

   BUCKET = "csos-telemetry"

   def show
       creds = "com.amazon.access.cs-os-prod-murdoch-1"
       Aws.config[:credentials] = Aws::OdinCredentials.new(creds)
       s3_client = Aws::S3::Client.new(region: "us-east-1")

       @s3objs = s3_client.list_objects({
         bucket: BUCKET,
         prefix: params[:id]
       }).contents

      @audit_logins =  Audit.where(clientId: params[:id])
            .where("type = 'login'")
            .order("createddate desc")
            .limit(10)
      @audit_updates =  Audit.where(clientId: params[:id])
            .where("type = 'updateEvent'")
            .order("createddate desc")
            .limit(10)

      @client = Client.where("audit_update_date >= (select max(audit_update_date) from csosclientmetadata as m2 where m2.id = csosclientmetadata.id) ")
      .find(params[:id])
   end

  def file
    creds = "com.amazon.access.cs-os-prod-murdoch-1"
    Aws.config[:credentials] = Aws::OdinCredentials.new(creds)
    s3_client = Aws::S3::Client.new(region: "us-east-1")

    @object = s3_client.get_object(bucket: BUCKET, key: "#{params[:id]}/#{params[:event]}/#{params[:file]}")
  end
end
