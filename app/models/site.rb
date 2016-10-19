class Site 

attr_accessor :id
attr_accessor :clients

SUMMARY_QUERY = "select count(distinct id), site " +
     "from csosclientmetadata as m1 " +
     "where audit_update_date >= (select max(audit_update_date) from csosclientmetadata as m2 where m2.id = m1.id) " +
     "group by site " + 
      "order by site asc " 

SITE_QUERY = "select * from csosclientmetadata limit 10"

  def initialize row
    @id = row['site']
    @clients = row['count']
  end

  def self.summary
    @credentials = Amazon::Odin.retrieve_pair("com.amazon.csos.redshift.audit.query")
    @pgdb = PG.connect( host: "csos-dw.czitwa6oewxw.us-east-1.redshift.amazonaws.com", port: "8192", user: @credentials.public.text.chomp, password: @credentials.private.text.chomp, dbname: "clientsdw")

    sites = []
    @pgdb.exec(SUMMARY_QUERY) do |result|
        result.each do |row| 
          sites.push Site.new(row)
        end 
    end 
    sites
  end

end
