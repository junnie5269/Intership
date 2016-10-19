class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Be aware, if you use :reset_session as the strategy here Kerberos will
  # interfere since we determine the remote user not with sessions but with the
  # Kerberos token instead.
  protect_from_forgery with: :exception

  # Set @remote_user for all routes
  before_action :initialize_remote_user
  def initialize_remote_user
    @remote_user = 
      if request.env['REMOTE_USER'].present?
        request.env['REMOTE_USER'].chomp('@ANT.AMAZON.COM')
      else
        ENV['REMOTE_USER']
      end
  end

  around_filter :with_query_logging

  # If a controller needs to add to the query log entry
  #
  def query_log_entry
    @top_query_log_entry
  end

  private
  def with_query_logging
    remote_req = request.env['remote.request'] || {}

    query_log_entry = Amazon::QueryLog::Entry.new("#{params[:controller].to_s}/#{params[:action]}", @request_id)
    @top_query_log_entry = query_log_entry
 
    query_log_entry["RemoteIpAddress"] = remote_req['Host']
    query_log_entry["UserAgent"] = request.env['HTTP_USER_AGENT']
    query_log_entry["RequestMethod"] = request.env['REQUEST_METHOD']
    query_log_entry["URL"] = request.fullpath
    query_log_entry["QueryString"] = request.query_string
    query_log_entry["RemoteUser"] = request.env['REMOTE_USER']

    # Yield to rails for rendering
    yield
  ensure
    # Always write the log entry (even if we threw an exception)
    query_log_entry["EndTime"] = Time.now.utc
    query_log_entry.time = query_log_entry["EndTime"] - query_log_entry.start_time
    Amazon::QueryLog::puts(query_log_entry)
  end
end
