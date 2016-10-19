class ErrorsController < ApplicationController 
  def routing 
    referer = request.env['HTTP_REFERER']
    if referer.present? && referer.include?(request.host)
      Rails.logger.fatal "#{referer} directs to non-existant route: #{request.protocol}#{request.host_with_port}#{request.fullpath}"
    else
      Rails.logger.warn "There was an attempt to access non-existant route: #{request.protocol}#{request.host_with_port}#{request.fullpath}"
    end
    render file: "#{Rails.root.to_s}/public/404.html", status: :not_found
  end 
end
