require 'sinatra'

post '/' do
	splitArray = request.body.split(',')
	splitArray.to_json
	#splitArray.each {|x| }
end
