class HealthController < ApplicationController
  def check
    render json: { 
      status: 'ok',
      message: 'API is running',
      version: '1.0.0',
      ruby_version: RUBY_VERSION,
      rails_version: Rails.version,
      environment: Rails.env,
      timestamp: Time.now.utc.iso8601
    }
  end
end
