require 'reloader/sse'
class PostsController < ApplicationController
  include ActionController::Live

  def index
    @posts = Post.all
  end

  def live
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Reloader::SSE.new(response.stream)
    begin
      100.times do
        sse.write({:time => Time.now.strftime('%r')}, :event => 'refresh')
        sleep 1
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
      Rails.logger.info "client disconnected"
    ensure
      sse.close
    end
  end
end
