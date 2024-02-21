class CoursesController < ApplicationController
	def index
		url = URI("https://developers.teachable.com/v1/courses")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true

		request = Net::HTTP::Get.new(url, {'apiKey': '7JbSA3ep6XOMV3t8t7QXuXq9HS79Dwnr'})
		request["accept"] = 'application/json'

		response = http.request(request)
		@results = JSON.parse(response.body, symbolize_names: true)
	end
end
