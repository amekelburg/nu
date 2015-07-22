class Admin::SeedingController < Admin::BaseController

  include ActionController::Live

  layout 'bare'

  # seeding screen
  def show
  end

  # runs the seeding script
  def perform
    user = 'deterboss'
    pass = params[:pass]

    response.headers['Content-Type'] = 'text/event-stream;charset=UTF-8'
    response.headers['Cache-Control'] = 'no-cache'
    SeedTestData.new(user, pass).perform do |log|
      response.stream.write("id: 1\ndata: #{log}\n\n")
    end
    response.stream.write("event: finish\ndata: ok\n\n")
  rescue => e
    response.stream.write("event: error\ndata: #{e.message}\n\n")
  ensure
    response.stream.close
  end

end
