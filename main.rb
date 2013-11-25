require 'sinatra'
require 'mongoid'
require 'json'

Mongoid.load!("mongoid.yml")
set :protection, :origin_whitelist => ['chrome-extension://hgmloofddffdnphfgcellkdfbfbjeloo']

post '/' do
	splitArray = request.body.string.split(',')

	session = Session.create(
		dateRecorded: DateTime.now
	)

	limit = splitArray.length - 3

	splitArray.each_index do |index|
		if index > limit
			break
		end

		if isStartOfSet(index)
			session.measurements.create(
				X: splitArray.at(index),
				Y: splitArray.at(index + 1),
				Z: splitArray.at(index + 2)
			)
		else
			next
		end
	end

	session.to_json
end

get '/' do
	returnArray = Array.new
	Session.each do |session|
		returnArray.push(session)
	end

	return returnArray.to_json
end

get '/deleteSession' do
	Session.delete_all
end

def isStartOfSet(val)
	if val == 0
		return true
	end

	i = 3

	until i > val
		if i == val
			return true
		end
		i = i + 3
	end
end

class Session
	include Mongoid::Document

	field :dateRecorded, type: DateTime

	embeds_many :measurements
end

class Measurement
	include Mongoid::Document

	field :X, type: Float
	field :Y, type: Float
	field :Z, type: Float

	embedded_in :session
end