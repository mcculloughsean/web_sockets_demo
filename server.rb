require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'haml'
require 'pusher'
require 'json'
require 'fileutils'
require 'base64'
require 'uri'

Pusher.app_id = '1350'
Pusher.key = '2f26b8b3ea8bbda5ec02'
Pusher.secret = '6d6063afe5941083e5da'

CHANNEL = 'demo_chat'

set :haml, {:format => :html5 }

def push(msg, data = {})
  Pusher[CHANNEL].trigger(msg, data)
end
def guess_content_type (filename)
  /^#{filename}: ([^,]+).*$/.match(`file -i #{filename}`)[1].downcase || nil
end

get '/' do
  haml :chat
end

post '/' do
  content_type :json
  unless params[:message][:file] # &&
   #    (tmpfile = params[:message][:file][:tempfile]) &&
   #    (name = params[:message][:file][:filename])
    # Filename and Contents
    filename = params[:message][:file][:tempfile].path
    contents = File.read(filename)
    base64 = Base64.encode64(contents).gsub("\n",'')
    puts filename
    # Mime Type for the Filename
    output = `file -I #{filename}`
    puts output
    mime = ''
    #mime = output.match( /: (.*)$/ )[1].downcase.gsub(/\s/,'')

    # Make Data URI
    datauri = "data:#{mime};base64,#{base64}"
    push('image_posted', dataur)
  else


    push('message_posted', params[:message])
  end
  {:status => :ok}.to_json

end
post '/upload' do


end
