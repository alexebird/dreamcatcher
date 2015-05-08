require 'bundler'
Bundler.require(:default)

before do
  pass unless request.accept? 'application/json'
  request.body.rewind
  body = request.body.read
  @request_payload = body.empty? ? {} : JSON.parse(body)
end

post '/dreamcatcher/rspec_hook_event/:hook_method.json', provides: :json do
  data = { params[:hook_method] => @request_payload }
  ap data
end
