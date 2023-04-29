require 'sinatra'
require 'sinatra/reloader'

use Rack::Auth::Basic do |username, password|
  username == ARGV[0] && password == ARGV[1]
end

def url2bib(url)
  curl = <<~CURL
  curl -L #{url} \
    -H 'Accept: application/x-bibtex'
  CURL
  IO.popen(curl, &:read).gsub(/\n/, '&#13;').gsub(/\t/, '&#9;').gsub(/\\/, '&#92;')
end

get '/' do
  erb :index
end

post '/' do
  bib_arr = []
  params[:url].split(/\r\n/).each do |url|
    bib = url2bib(url)
    bib_arr.push(bib)
  end
  @bib = bib_arr.join('&#13;')
  erb :index
end
