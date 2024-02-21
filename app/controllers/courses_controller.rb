class CoursesController < ApplicationController
	def index
		api_key = ENV['TEACHABLE_API_KEY']
		url = URI("https://developers.teachable.com/v1/courses")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true

		request = Net::HTTP::Get.new(url, {'apiKey': api_key})
		request["accept"] = 'application/json'

		response = http.request(request)
		@results = JSON.parse(response.body, symbolize_names: true)

		@full_results = Hash.new()
		@student_results = Hash.new()
		@results[:courses].each do |c|
			if c[:is_published]
				url = URI("https://developers.teachable.com/v1/courses/#{c[:id]}/enrollments")

				http = Net::HTTP.new(url.host, url.port)
				http.use_ssl = true

				request = Net::HTTP::Get.new(url, {'apiKey': api_key})
				request["accept"] = 'application/json'

				response = http.request(request)
				results = JSON.parse(response.body, symbolize_names: true)

				@full_results[c[:id]] = results

				if @full_results[c[:id]][:enrollments] != nil
					@student_results[c[:id]] = []
					@full_results[c[:id]][:enrollments].each do |u|
						if (u[:completed_at] == nil && (u[:expires_at] == nil || u[:expires_at] > Time.now()))

							url = URI("https://developers.teachable.com/v1/users/#{u[:user_id]}")
							http = Net::HTTP.new(url.host, url.port)
							http.use_ssl = true

							request = Net::HTTP::Get.new(url, {'apiKey': api_key})
							request["accept"] = 'application/json'

							response = http.request(request)
							results = JSON.parse(response.body, symbolize_names: true)

							@student_results[c[:id]] << results
						end
					end
				end
			end
		end
		@student_results
	end
end
